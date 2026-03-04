# AI Fashion Chatbot – Integrace modelu LLaMA 3 do mobilní aplikace

Bakalářská práce  
Vývoj chatbota na bázi transformátoru v mobilní aplikaci  

Autor: Nila Bakulina  
Repozitář: https://github.com/bakulinanila-prog/ai-fashion-chatbot-llama3  

---

## 1. Popis projektu

Tento projekt představuje implementaci inteligentního chatbota založeného na transformátorovém modelu LLaMA 3, který je integrován do mobilní aplikace módního e-shopu.

Cílem projektu je umožnit uživatelům:

- Vyhledávání produktů pomocí přirozeného jazyka  
- Generování outfitů na základě pohlaví a příležitosti  
- Filtrování produktů podle ceny, sezóny a úrovně formálnosti  
- Interaktivní konverzační komunikaci v mobilní aplikaci  

Projekt demonstruje praktické využití velkých jazykových modelů (LLM) v oblasti e-commerce.

---

## 2. Architektura řešení

Systém je rozdělen do dvou hlavních částí:

### Backend (Python + Flask)

- Implementace REST API  
- Integrace modelu LLaMA 3 prostřednictvím nástroje Ollama  
- Pravidlový generátor outfitů  
- Filtrování produktů z JSON databáze  

### Mobilní aplikace (Flutter)

- Chatové uživatelské rozhraní  
- Interaktivní tlačítka (Build outfit, volba pohlaví, volba příležitosti)  
- Zobrazení produktů  
- Přidání produktů do košíku  

Datový tok systému:

Mobilní aplikace → REST API → Backend (Flask) → LLaMA 3 (Ollama, lokálně) → Produktová databáze (JSON)

---

## 3. Funkcionalita systému

### 3.1 Vyhledávání pomocí přirozeného jazyka

Uživatel může zadat například:

- women winter coat under 3000  
- elegant dress for party under 4000  
- men sporty shoes for summer  

Systém analyzuje text a extrahuje následující parametry:

- gender  
- subcategory  
- season  
- formality  
- max_price  

Na základě těchto parametrů jsou produkty filtrovány z lokální databáze.

---

### 3.2 Generování outfitů

Aplikace obsahuje interaktivní scénář:

1. Build me an outfit  
2. Volba pohlaví  
3. Volba příležitosti (Casual / Office / Evening)  

Backend následně generuje outfit na základě předdefinovaných kombinací kategorií.

Příklad kombinací:

Women + Office → blouse + skirt + blazer + shoes  
Men + Casual → jeans + t-shirt + sneakers  

---

## 4. Použité technologie

- Python 3.11  
- Flask  
- Ollama  
- LLaMA 3  
- Flutter  
- Provider (state management)  
- REST API  
- JSON databáze produktů  

---

## 5. Požadavky na systém

Projekt byl testován na následujícím prostředí:

- Windows 11  
- Python 3.11  
- Flutter 3+  
- Android Emulator  
- Minimálně 8 GB RAM (doporučeno)  

---

## 6. Kompletní návod ke spuštění projektu

### 6.1 Klonování repozitáře

git clone https://github.com/bakulinanila-prog/ai-fashion-chatbot-llama3.git

cd ai-fashion-chatbot-llama3

---

### 6.2 Instalace a konfigurace backendu

1. Přejděte do složky backend:

cd backend

2. Doporučuje se vytvořit virtuální prostředí:

python -m venv venv

3. Aktivace prostředí (Windows):

venv\Scripts\activate

4. Instalace závislostí:

pip install flask requests ollama

---

### 6.3 Instalace Ollama

1. Stáhněte instalační balíček z:

https://ollama.com/

2. Ověření instalace:

ollama list

---

### 6.4 Stažení modelu LLaMA 3

1. ollama pull llama3

Model má velikost přibližně 4–5 GB.

---

### 6.5 Spuštění modelu

1. Před spuštěním backendu je nutné model aktivovat:

ollama run llama3

Bez tohoto kroku nebude backend schopen generovat odpovědi.

---

### 6.6 Spuštění backendu

1. Otevřete novou konzoli a přejděte do složky backend:

cd backend
python app.py

2. Server běží na adrese:

http://127.0.0.1:5000

3. Kontrola funkčnosti:

http://127.0.0.1:5000/health

---

### 6.7 Spuštění mobilní aplikace

1. Přejděte do složky mobilní aplikace:

cd fashion_chat_app

2. Instalace balíčků:

flutter pub get

3. Spuštění aplikace:

flutter run

Je nutné mít spuštěný Android Emulator.

Mobilní aplikace komunikuje s backendem přes adresu:

http://10.0.2.2:5000

---

## 7. Testování systému

Po úspěšném spuštění lze otestovat následující scénáře:

Vyhledávání produktů:

- women winter coat under 3000

- elegant dress for party under 4000

- men sporty shoes for summer

Generování outfitů:

- Build me an outfit

- Volba pohlaví

- Volba příležitosti

Ověřované parametry:

- Správnost extrahovaného intentu

- Relevance vrácených produktů

- Konzistence odpovědí

- Latence systému

---

## 8. Výkonnost systému

- Průměrná latence odpovědi modelu LLaMA: 7–10 sekund

- Latence pravidlového outfit engine: méně než 0,01 sekundy

- Databáze obsahuje více než 100 produktů

---

## 9. Bezpečnost

- Model běží lokálně bez využití cloudových API

- Žádný přenos uživatelských dat třetím stranám

- Architektura je v souladu s požadavky GDPR

- Uživatelská data nejsou ukládána

---

## 10. Kontext bakalářské práce

Projekt je součástí bakalářské práce s názvem:

„Vývoj chatbota na bázi transformátoru v mobilní aplikaci“

Praktická část zahrnuje:

- Implementaci backendového API

- Integraci modelu LLaMA 3

- Návrh konverzační logiky

- Testování relevance odpovědí

- Analýzu latence systému

---

## 11. Licence

Projekt byl vytvořen pro vzdělávací účely v rámci bakalářské práce. 