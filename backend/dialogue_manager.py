from collections import defaultdict


class DialogueManager:

    def __init__(self):
        self.sessions = defaultdict(lambda: {
            "mode": None,
            "gender": None,
            "formality": None
        })

    def get_state(self, session_id):
        return self.sessions[session_id]

    def reset(self, session_id):
        self.sessions[session_id] = {
            "mode": None,
            "gender": None,
            "formality": None
        }