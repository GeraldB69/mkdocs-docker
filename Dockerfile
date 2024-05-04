FROM squidfunk/mkdocs-material:latest

ADD requirements.txt .

RUN pip install --upgrade pip && pip install -r requirements.txt
