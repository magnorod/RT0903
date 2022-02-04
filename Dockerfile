FROM faucet/python3
COPY code /code
WORKDIR /code
RUN pip install flask redis \
&& chmod -R  700 /code
ENTRYPOINT [ "/code/motd-api.py" ]