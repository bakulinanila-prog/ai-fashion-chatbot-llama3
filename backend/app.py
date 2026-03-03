from flask import Flask, request, jsonify
import requests
import json
import time
import random
from data_loader import load_products

app = Flask(__name__)

products = load_products()
print(f"Loaded products: {len(products)}")

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "llama3"


# ======================================
# HEALTH
# ======================================
@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})


# ======================================
# SIMPLE PARSER (FAST RULE-BASED)
# ======================================
def simple_parse(message):

    message = message.lower()

    gender = None
    subcategory = None
    formality = None

    if "women" in message:
        gender = "women"
    elif "men" in message:
        gender = "men"
    elif "kids" in message:
        gender = "kids"

    replacements = {
        "jackets": "jacket",
        "coats": "coat",
        "dresses": "dress",
        "skirts": "skirt",
        "shoes": "shoes",
        "jeans": "jeans",
        "tshirts": "tshirt",
        "sweaters": "sweater",
        "hoodies": "hoodie"
    }

    for key in replacements:
        if key in message:
            subcategory = replacements[key]
            break

    possible = [
        "jacket", "coat", "dress", "skirt",
        "shoes", "jeans", "tshirt", "sweater", "hoodie"
    ]

    if not subcategory:
        for p in possible:
            if p in message:
                subcategory = p
                break

    if "office" in message:
        formality = "office"
    elif "casual" in message:
        formality = "casual"
    elif "evening" in message:
        formality = "evening"

    return {
        "gender": gender,
        "subcategory": subcategory,
        "formality": formality
    }


# ======================================
# CALL LLAMA FOR COMPLEX TEXT
# ======================================
def call_llama_for_intent(message):

    prompt = f"""
You are an AI that extracts shopping intent from user message.
Return ONLY valid JSON.

Extract:
- gender (women, men, kids or null)
- subcategory (jacket, coat, dress, skirt, shoes, jeans, tshirt, sweater, hoodie or null)
- formality (office, casual, evening or null)

User message:
{message}

JSON:
"""

    try:
        response = requests.post(
            OLLAMA_URL,
            json={
                "model": MODEL_NAME,
                "prompt": prompt,
                "stream": False
            }
        )

        result = response.json().get("response", "")

        # Извлекаем JSON из текста
        start = result.find("{")
        end = result.rfind("}") + 1
        json_str = result[start:end]

        intent = json.loads(json_str)

        print("LLAMA INTENT:", intent)

        return intent

    except Exception as e:
        print("LLaMA error:", e)
        return {}


# ======================================
# FILTER WITH FALLBACK
# ======================================
def filter_products(intent):

    filtered = products

    # ---- GENDER ----
    if intent.get("gender"):
        filtered = [
            p for p in filtered
            if p.get("gender", "").lower() == intent["gender"]
        ]

    # ---- SUBCATEGORY ----
    if intent.get("subcategory"):
        sub = intent["subcategory"].lower()
        filtered = [
            p for p in filtered
            if sub in p.get("subcategory", "").lower()
            or sub in p.get("type", "").lower()
        ]

    # ---- FORMALITY WITH FALLBACK ----
    if intent.get("formality"):

        with_formality = [
            p for p in filtered
            if intent["formality"]
            in [f.lower() for f in p.get("formality", [])]
        ]

        if len(with_formality) > 0:
            filtered = with_formality
        else:
            print("No formality match, fallback without formality")

    return filtered


# ======================================
# OUTFIT BUILDER
# ======================================
def build_template_outfit(gender, formality):

    templates = {
        "women": {
            "office": ["skirt", "sweater", "jacket", "shoes"],
            "casual": ["jeans", "tshirt", "sweater", "shoes"],
            "evening": ["dress", "jacket", "shoes"]
        },
        "men": {
            "office": ["jacket", "jeans", "shoes"],
            "casual": ["jeans", "tshirt", "hoodie", "shoes"],
            "evening": ["jacket", "tshirt", "shoes"]
        }
    }

    required = templates.get(gender, {}).get(formality, [])

    outfit = []

    for subcat in required:
        candidates = [
            p for p in products
            if p.get("gender", "").lower() == gender
            and (
                subcat in p.get("subcategory", "").lower()
                or subcat in p.get("type", "").lower()
            )
        ]

        if candidates:
            outfit.append(random.choice(candidates))

    return outfit


# ======================================
# CHAT (HYBRID ARCHITECTURE)
# ======================================
@app.route("/chat", methods=["POST"])
def chat():

    start_time = time.time()

    data = request.json or {}
    message = data.get("message", "").lower()

    parsed_simple = simple_parse(message)

    # ---- OUTFIT ----
    if "outfit" in message:
        print("Using rule-based outfit engine")
        results = build_template_outfit(
            parsed_simple.get("gender"),
            parsed_simple.get("formality")
        )

    else:
        words = message.split()
        is_complex = len(words) > 3

        if is_complex:
            print("Calling LLaMA...")
            parsed = call_llama_for_intent(message)
        else:
            print("Using simple parser")
            parsed = parsed_simple

        results = filter_products(parsed)[:12]

    latency = round(time.time() - start_time, 3)
    print("LATENCY:", latency)

    return jsonify({
        "reply": {
            "message": "Here are your results.",
            "products": [p["id"] for p in results],
            "latency": latency
        }
    })


if __name__ == "__main__":
    app.run(debug=True)