FROM python:alpine
COPY docker-entrypoint.sh /
ARG SCRIPT_URL=https://github.com/srcrs/UnicomTask.git
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    PS1="\u@\h:\w \# " \
    SCRIPT_BRANCH=main \
    SCRIPT_DIR=/UnicomTask
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
                             git \
                             tzdata \
                             g++ \
                             gcc \
                             libxslt-dev \
                             libxml2-dev \
    && git clone -b ${SCRIPT_BRANCH} ${SCRIPT_URL} ${SCRIPT_DIR} \
    &&  pip install --no-cache-dir -r requirements.txt \
    && rm -rf /var/cache/* \
    && chmod +x /docker-entrypoint.sh
WORKDIR ${SCRIPT_DIR}
ENTRYPOINT /docker-entrypoint.sh