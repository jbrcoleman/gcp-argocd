import requests
import logging
import os
from time import sleep
from PIL import Image, ImageChops
from io import BytesIO

IP = os.environ['EXTERNAL_IP']

# URL of the GoLang service displaying the Gopher
SERVICE_URL = f"http://{IP}"

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("service_check.log"),  # Log to file
        logging.StreamHandler()  # Log to console
    ]
)

def check_service():
    try:
        response = requests.get(SERVICE_URL, timeout=5)
        # Check if the service is up (status code 200)
        if response.status_code == 200:
            logging.info("Service is up!")
            check_image()
        else:
            logging.warning(f"Service returned status: {response.status_code}")
            notify_service_down()
    except requests.exceptions.RequestException as e:
        logging.error(f"Error connecting to service: {e}")
        notify_service_down()

def check_image():
    try:
        # Load the returned image and compare it with the original gopher image
        img = Image.open("/app/static/gopher.png")
    except IOError as e:
        logging.error(f"Error loading image from service: {e}")
        return
    
    try:
        original_gopher_path = os.path.join(os.path.dirname(__file__), 'static', 'gopher.png')
        original_gopher = Image.open(original_gopher_path)
    except IOError as e:
        logging.error(f"Error loading original gopher image: {e}")
        return
    
    diff = ImageChops.difference(img, original_gopher)
    # Compare the images (this is a simplistic approach, just comparing sizes here)
    if diff.getbbox():
        logging.warning("Images are different")
        notify_image_changed()
    else:
        logging.info("Images are the same")

def notify_service_down():
    # Placeholder for notifying about service being down
    logging.error("Service is down! Sending notification...")

def notify_image_changed():
    # Placeholder for notifying about image changes
    logging.info("Gopher image has changed! Sending notification...")

if __name__ == "__main__":
    while True:
        check_service()
        sleep(60)  # Check every 60 seconds
