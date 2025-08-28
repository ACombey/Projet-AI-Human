# app.py

import mlflow
from mlflow import log_param, log_metric, start_run

def main():
    with start_run():
        log_param("param1", 5)
        log_metric("metric1", 0.85)
    print("Run logged successfully!")

if __name__ == "__main__":
    main()

