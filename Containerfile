FROM golang:1.18 as builder

WORKDIR /go/src/github.com/fbdlampayan/k8s-device-plugin/

COPY . /go/src/github.com/fbdlampayan/k8s-device-plugin/

RUN go get -v github.com/intel/intel-device-plugins-for-kubernetes/pkg/deviceplugin@v0.23

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o fbdl -v main.go

FROM ubi8-minimal:8.5

WORKDIR /work/

COPY --from=builder /go/src/github.com/fbdlampayan/k8s-device-plugin/fbdl .

ENV CAPACITY 5
ENTRYPOINT ./fbdl -capacity=$CAPACITY
