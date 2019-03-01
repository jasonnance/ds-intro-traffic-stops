# Intro to Practical Data Science: Traffic Stop Analysis

## Usage

Requirements: Docker/docker-compose.

Run:

    docker-compose up -d jupyter
    
Then navigate to [http://localhost:8888](http://localhost:8888) in your browser.  Open `Analysis.ipynb`.

## Setup

Requirements: a UNIX-like OS (Mac or Linux), unzip, wget, xz, and Docker/docker-compose.

Run:

    ./init.sh


This will download the dataset and begin the docker container import.  The database will take several minutes to restore.

Verify the database is done restoring:

    docker-compose exec database bash -c 'psql -U "$POSTGRES_USER" -c "SELECT COUNT(*) FROM analysis_view;"'

This should print:

      count
    ---------
     1334379
    (1 row)

Then run the following script to export and compress the dataset:

    ./export_data.sh
