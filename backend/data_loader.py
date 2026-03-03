import json
import os
from config import JSON_PATH


def load_products():
    if not os.path.exists(JSON_PATH):
        raise FileNotFoundError(f"JSON not found at {JSON_PATH}")

    with open(JSON_PATH, "r", encoding="utf-8-sig") as f:
        return json.load(f)