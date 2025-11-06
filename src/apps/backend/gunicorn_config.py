import multiprocessing

# Server Socket
bind = "0.0.0.0:8080"

# Worker Processes
# Reduced to 1 worker for development to prevent memory issues in Docker
workers = 1
worker_class = "gthread"
threads = 4

# Logging
loglevel = "info"
accesslog = "-"
access_log_format = "app - request - %(h)s - %(s)s - %(m)s - %(M)sms - %(U)s - %({user-agent}i)s"
errorlog = "-"

# Timeout
timeout = 120  # Increased timeout for slow imports
keepalive = 2
preload_app = False  # Don't preload to avoid import issues
