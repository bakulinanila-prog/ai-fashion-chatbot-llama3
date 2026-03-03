import re


class NLPProcessor:

    def __init__(self, products):

        self.subcategories = set(p["subcategory"] for p in products)
        self.types = set(p["type"] for p in products)

        self.gender_map = {
            "women": "women",
            "woman": "women",
            "men": "men",
            "man": "men",
            "kids": "kids",
            "kid": "kids"
        }

        self.season_map = {
            "winter": "winter",
            "summer": "summer",
            "spring": "spring",
            "autumn": "autumn",
            "fall": "autumn"
        }

    def singularize(self, word):

        # dresses → dress
        if word.endswith("es"):
            if word[:-2] in self.subcategories:
                return word[:-2]

        # jackets → jacket
        if word.endswith("s"):
            if word[:-1] in self.subcategories:
                return word[:-1]

        return word

    def parse(self, message):

        words = re.findall(r"[a-zA-Z]+", message.lower())

        result = {
            "gender": None,
            "season": None,
            "type": None,
            "subcategory": None
        }

        for word in words:

            # Gender
            if word in self.gender_map:
                result["gender"] = self.gender_map[word]

            # Season
            if word in self.season_map:
                result["season"] = self.season_map[word]

            # Plural fix
            clean_word = self.singularize(word)

            # Subcategory strict
            if clean_word in self.subcategories:
                result["subcategory"] = clean_word

            # Type fallback
            elif word in self.types:
                result["type"] = word

        return result