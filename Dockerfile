FROM pandoc/core:3-ubuntu
RUN apt-get update && apt-get install -y --no-install-recommends fonts-dejavu-core && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY . .

RUN chmod +x gen.sh

EXPOSE 80
ENTRYPOINT []
CMD ./gen.sh
