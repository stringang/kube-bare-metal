FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

ENV JMX_EXPORTER_VERSION=0.3.1

RUN microdnf update -y \
    && microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y ca-certificates wget \
    && microdnf reinstall -y tzdata \
    && microdnf clean all -y

ADD rootfs /

WORKDIR /opt/javaagent
RUN wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" && \
  wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  echo "$(cat "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1")" "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" | sha1sum -c - && \
  rm "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  ln -s "/opt/javaagent/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" "/opt/javaagent/jmx_prometheus_javaagent.jar"

# 启动 JMX Exporter：
# -javaagent:/opt/javaagent/jmx_prometheus_javaagent.jar=9404:/opt/javaagent/jmx-exporter-config.yaml