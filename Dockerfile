FROM python:3.7
RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
RUN apt-get update && apt-get upgrade -y
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY --chown=uwsgi:uwsgi bot.py /app/bot.py
COPY --chown=uwsgi:uwsgi hsbot /app/hsbot
COPY --chown=uwsgi:uwsgi manage.py /app/manage.py
COPY --chown=uwsgi:uwsgi tests /app/tests
COPY --chown=uwsgi:uwsgi uwsgi.ini /app/uwsgi.ini
COPY --chown=uwsgi:uwsgi cmd.sh /app/cmd.sh

EXPOSE 9090
USER uwsgi
ENV TZ=Asia/Tokyo
ENV LINE_CHANNEL_ACCESS_TOKEN = "YOUR_CHANNEL_ACCESS_TOKEN"
ENV LINE_CHANNEL_SECRET = "YOUR_CHANNEL_SECRET"

RUN python manage.py init_db && python manage.py insert_observatories
RUN python -m unittest discover tests

VOLUME ["/app/hsbot/database"]
CMD ["./cmd.sh"]
