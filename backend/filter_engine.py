class ProductFilter:

    def __init__(self, products):
        self.products = products

    def apply(self, filters):

        results = self.products

        # Gender (strict)
        if "gender" in filters:
            results = [
                p for p in results
                if p["gender"] == filters["gender"]
            ]

        # Season (strict)
        if "season" in filters:
            results = [
                p for p in results
                if filters["season"] in p.get("season", [])
                or "all_season" in p.get("season", [])
            ]

        # Formality (strict)
        if "formality" in filters:
            results = [
                p for p in results
                if filters["formality"] in p.get("formality", [])
            ]

        # Subcategory (strict) 
        if "subcategory" in filters:
            results = [
                p for p in results
                if p.get("subcategory") == filters["subcategory"]
            ]
            return results

        # Type only if no subcategory
        if "type" in filters:
            results = [
                p for p in results
                if p.get("type") == filters["type"]
            ]

        return results