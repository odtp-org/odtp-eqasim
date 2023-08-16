from pymongo import MongoClient, errors
from bson import ObjectId
from datetime import datetime
import os
import time


def connectClient():
    client = MongoClient(os.environ["MONGODB_CLIENT"])
    db=client.defaultdb
    return client, db

def createComponentEntry(db, collectionTag=None): 
    if not collectionTag: 
        # Choose your collection (replace 'mycollection' with your collection name)
        collection = db['logs']

        # Create a document with a timestamp
        document = {
            "type": "log",
            "data":[{
            "timestamp": datetime.utcnow(),
            "author": "Author Test",
            "message": "Initial Log Message ODTP - Eqasim"
            }]
        }

        # Insert the document into the collection
        result = collection.insert_one(document)

        # Print the ID of the new document
        print(f"Inserted document with ID: {result.inserted_id}")

    else:
        print("retrieve collection and add document") #TODO

    return result.inserted_id


def update(newLogEntry, client, db, docID, collectionTag="logs"):
    # Make sure the ID is a valid ObjectId
    try:
        valid_id = ObjectId(docID)
    except errors.InvalidId:
        print("Invalid ID format!")
        client.close()
        exit()

    collection = db[collectionTag]

    # Update the document by pushing the new_log_entry to the data array
    result = collection.update_one({"_id": valid_id}, {"$push": {"data": newLogEntry}})

    # Print result and add verbose. 
    if result.modified_count > 0:
        print(f"Document with ID {docID} was updated.")
    else:
        print(f"No documents with ID {docID} were found and updated.")


########### LogReader 
class LogReader:
    def __init__(self, log_file):
        self.log_file = log_file
        self.last_position = 0

    def read_from_last_position(self):
        with open(self.log_file, 'r') as f:
            # Move to the last read position
            f.seek(self.last_position)

            # Read the remaining lines from the log file
            for line in f:
                yield line.strip()

            # Update the last read position
            self.last_position = f.tell()

def main(delta=2):
    ### Create Entry
    client, db =  connectClient()
    docID = createComponentEntry(db)
    client.close()

    log_reader = LogReader('/odtp/odtp-workdir/log.txt')

    while True:
        logs = log_reader.read_from_last_position()
        client, db =  connectClient() #This opening closing can bring some issues in the future when delta is really small. 

        for log in logs:
            newLogEntry= {
            "timestamp": datetime.utcnow(),
            "author": "Author Test",
            "message": log}

            update(newLogEntry, client, db, docID, collectionTag="logs")

        client.close()

        #TODO: Improve this
        if log == "--- ODTP COMPONENT ENDING ---":
            break

        time.sleep(delta)

if __name__ == '__main__':
    main(delta=2)