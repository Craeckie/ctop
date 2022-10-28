FROM golang:alpine as build

WORKDIR /app
COPY go.mod .
RUN go mod download

COPY . .
RUN apk add --virtual .build make git && \
    make build && \
    apk del .build && \
    mkdir -p /go/bin && \
    mv -v ctop /go/bin/

FROM scratch
ENV TERM=linux
COPY --from=build /go/bin/ctop /ctop
ENTRYPOINT ["/ctop"]
