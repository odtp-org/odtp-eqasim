from pymongo import MongoClient, errors
from bson import ObjectId
from datetime import datetime
import os
import time

### This method needs to create a new entry in snapshots MONGODB and upload the output.zip to s3. 
### At this moment the structure is not that important as to make things works together. 

import boto3
from botocore.exceptions import NoCredentialsError

class MinioS3Uploader:
    def __init__(self, endpoint_url, access_key, secret_key, bucket_name):
        self.s3 = boto3.client('s3', 
                               endpoint_url=endpoint_url, 
                               aws_access_key_id=access_key, 
                               aws_secret_access_key=secret_key)
        self.bucket_name = bucket_name

    def upload_zip(self, zip_filepath, destination_key):
        """
        Uploads a zip file to the specified location in the bucket.

        :param zip_filepath: The local path to the zip file.
        :param destination_key: The S3 key (path) where the file should be uploaded.
        """
        try:
            self.s3.upload_file(zip_filepath, self.bucket_name, destination_key)
            print(f"Upload Successful: {zip_filepath} to {destination_key}")
            return True
        except FileNotFoundError:
            print("The file was not found")
            return False
        except NoCredentialsError:
            print("Credentials not available")
            return False
        
#####################################


def connectClient():
    client = MongoClient(os.environ["MONGODB_CLIENT"])
    db=client.odtp
    return client, db

def createSnapshotEntry(db, document, collectionTag=None): 
    if not collectionTag: 
        # Choose your collection (replace 'mycollection' with your collection name)
        collection = db['snapshots']
    else:
        collection = db[collectionTag]

    # Insert the document into the collection
    result = collection.insert_one(document)

    # Print the ID of the new document
    print(f"Inserted document with ID: {result.inserted_id}")

    return result.inserted_id



def mongoDBLog(document):
    ### Create Entry
    client, db =  connectClient()
    docID = createSnapshotEntry(db, document)
    client.close()

    return docID

#####################################


if __name__ == "__main__":
    S3_SERVER = os.environ["S3_SERVER"]
    ACCESS_KEY = os.environ["S3_ACCESS_KEY"]
    SECRET_KEY = os.environ["S3_SECRET_KEY"]
    BUCKET_NAME = os.environ["S3_BUCKET_NAME"] 

    uploader = MinioS3Uploader(S3_SERVER, ACCESS_KEY, SECRET_KEY, BUCKET_NAME)

    ## Upload compressed output
    uploader.upload_zip('/odtp/odtp-volume/output.zip', 'odtp/odtp-snapshots/output.zip')

    document = {
        "type": "output",
        "data":[{
        "timestamp": datetime.utcnow(),
        "author": "Author Test",
        "message": f"{S3_SERVER}/odtp/odtp-snapshots/output.zip"
        }]
    }

    _ = mongoDBLog(document)

    # TODO: Upload individual files to S3 (Experimental)

    ## Upload snapshot workdir
    uploader.upload_zip('/odtp/odtp-volume/snapshot.zip', 'odtp/odtp-snapshots/snapshot.zip')

    document = {
        "type": "snapshot",
        "data":[{
        "timestamp": datetime.utcnow(),
        "author": "Author Test",
        "message": f"{S3_SERVER}/odtp/odtp-snapshots/snapshot.zip"
        }]
    }

    _ = mongoDBLog(document)