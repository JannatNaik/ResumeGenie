import json
import spacy
from spacy.training.example import Example
# Example is a class used for training spaCy models.

# It combines your text and its entity labels into one object.

# You need it for nlp.update() during model training.

with open("dataset_jobdescription.json", encoding="utf-8") as f:
    TRAIN_DATA = json.load(f)

nlp = spacy.blank("en")
ner = nlp.add_pipe("ner")

# This way, you’re looping over just the annotated examples, not the whole dictionary.
for text, annotations in TRAIN_DATA["annotations"]:
    for ent in annotations.get("entities"):
        ner.add_label(ent[2])

other_pipes = [pipe for pipe in nlp.pipe_names if pipe != "ner"]
with nlp.disable_pipes(*other_pipes):
    optimizer = nlp.begin_training()
    for epoch in range(30):
        losses = {}
        for text, annotations in TRAIN_DATA["annotations"]:  # <-- FIXED HERE
            example = Example.from_dict(nlp.make_doc(text), annotations)
            nlp.update([example], drop=0.3, losses=losses)
        print(f"Epoch {epoch+1}: {losses}")

nlp.to_disk("custom_ner_model")
print("Model trained and saved to 'custom_ner_model'")
