#!/usr/bin/python3
import boto3
import os 
from subprocess import call
import time
import datetime

# Initializing the S3 client 
s3 = boto3.client('s3')
s3_download = boto3.resource('s3')#calling s3 as a diffrent object type for easy download

# Define the function to check for new .wav files
def check_for_wav_files(last_modified_time):
    # Get the S3 object metadata for the file named "iphone_recording.wav"
    try:
        obj = s3.head_object(Bucket='chattabox', Key='phone_recording.wav')
    except s3.exceptions.NoSuchKey:
        return last_modified_time
    # If the file is found and it was modified after the last run, play the notification sound
    if obj and obj['LastModified'] > last_modified_time:
        filepath = os.path.join(os.getcwd(),'phone_recording.wav')
        s3_download.Bucket('chattabox').download_file('phone_recording.wav',filepath)
        call(["aplay", "-D", "hw:1,0", "notification.wav"])
        last_modified_time = obj['LastModified']
    # Return the last modified time of the file, whether or not it was more recent than last run
    return last_modified_time

# Set the initial value for last modified time as None
last_modified_time = datetime.datetime.fromtimestamp(0, tz=datetime.timezone.utc)

# Loop indefinitely
while True:
    # Check for new .wav files with a more recent last modified time than the last run
    last_modified_time = check_for_wav_files(last_modified_time)
