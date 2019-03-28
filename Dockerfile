FROM python:3-alpine AS builder

WORKDIR /usr/src/app

COPY requirement.txt ./
RUN pip3 install -q --no-cache-dir -r requirement.txt -t ./
COPY . .
ADD https://raw.githubusercontent.com/instantbox/instantbox-images/master/manifest.json .


FROM gcr.io/distroless/python3

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="vm_image" \
  org.label-schema.vcs-url="https://github.com/mexious/vm_image" \
  maintainer="Developer Mexious <care@mexious.com>"

ENV SERVERURL ""

WORKDIR /app
COPY --from=builder /usr/src/app/ .

EXPOSE 65501
CMD ["inspire.py"]

ARG BUILD_DATE
ARG VCS_REF
LABEL \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF
