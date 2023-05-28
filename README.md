# Chatterbox
Chatterbox allows a person to use their phone to send a voice memo to a raspberry pi, and the person near the pi to respond with a voice message. This would be generally useful for younger children who don’t own mobile devices yet and parents who want to keep in touch with their children when they are out of town. Similarly, this example is applicable to the elderly, who aren’t necessarily technologically savvy. Grandchildren can keep in touch with their grandparents by using this pair of devices to communicate.

To see how this works live, click the following link for a demo. 
https://drive.google.com/file/d/1Zvqir0D51tDmGH3mbe0nGA_sI38jSu7C/view?usp=sharing

## Capabilities
1. Record, playback and send voice memo from iPhone to Raspberry Pi (RPI) and vice versa. 
2. When an iPhone sends a voice memo to the RPI, RPI is able to audibly notify you that a message has been received. 


## Technologies used
* iOS side: AWS to connect to Amazon S3 bucket, CocoaPods to install AWS3 and Swift for all implementation regarding the app
* raspberry-pi side: boto3 python library to connected to Amazon S3 bucket, supervisor script for running at plug-in

