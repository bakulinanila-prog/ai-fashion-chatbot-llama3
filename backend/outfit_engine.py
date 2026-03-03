import random


class OutfitBuilder:

    def __init__(self, products):
        self.products = products

    def build(self, gender, formality):

        pool = [
            p for p in self.products
            if p["gender"] == gender
            and formality in p.get("formality", [])
        ]

        if not pool:
            return []

        outfit = []

        def pick(type_name):
            items = [p for p in pool if p["type"] == type_name]
            return random.choice(items) if items else None

        if gender == "women":

            if formality == "evening":
                outfit.append(pick("dress"))
                outfit.append(pick("shoes"))
            else:
                outfit.append(pick("top"))
                outfit.append(pick("bottom"))
                outfit.append(pick("shoes"))

        elif gender == "men":

            if formality == "office":
                outfit.append(pick("set"))
                outfit.append(pick("shoes"))
            else:
                outfit.append(pick("top"))
                outfit.append(pick("bottom"))
                outfit.append(pick("shoes"))

        return [p for p in outfit if p]