#TEMPLATE TAKEN FROM DIGITAL_OCEAN PROJECT STRUCTURE
import os

# Statement for enabling the development environment
DEBUG = False

# Define the application directory
BASE_DIR = os.path.abspath(os.path.dirname(__file__))  

# Application threads. A common general assumption is
# using 2 per available processor cores - to handle
# incoming requests using one and performing background
# operations using the other.
THREADS_PER_PAGE = 1

# Enable protection agains *Cross-site Request Forgery (CSRF)*
CSRF_ENABLED     = True

# Use a secure, unique and absolutely secret key for
# signing the data. 
CSRF_SESSION_KEY = os.getenv('API_SECRET_KEY')

# Secret key for signing cookies
SECRET_KEY = os.getenv('API_SECRET_KEY')

