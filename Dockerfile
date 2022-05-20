FROM ubuntu:22.10

RUN apt update
RUN apt install -y ca-certificates curl
RUN apt install -y default-jdk

# Install latest su-exec
# https://gist.github.com/dmrub/b311d36492f230887ab0743b3af7309b
RUN set -ex; \
    curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
    fetch_deps='gcc libc-dev'; \
    apt-get update && \
    apt-get install -y --no-install-recommends $fetch_deps \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    gcc -Wall \
        /usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
    chown root:root /usr/local/bin/su-exec; \
    chmod 0755 /usr/local/bin/su-exec; \
    rm /usr/local/bin/su-exec.c; \
    apt-get purge -y --auto-remove $fetch_deps \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="/root/.local/share/coursier/bin:${PATH}"

RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /usr/local/bin/cs
RUN chmod +x /usr/local/bin/cs
RUN cs install scala:2.13.8 --dir /usr/share/coursier && cs install --dir /usr/share/coursier scalac:2.13.8
ENV PATH="$PATH:/usr/share/coursier"

RUN curl -L https://github.com/sbt/sbt/releases/download/v1.5.7/sbt-1.5.7.tgz | tar xvz -C /tmp 
RUN cp /tmp/sbt/bin/sbt /usr/local/bin/sbt && chmod uga+x /usr/local/bin/sbt

RUN useradd -ms /bin/zsh me
# RUN mkdir /home/me/.cache && chown me:me /home/me/.cache

COPY docker-entrypoint.sh /bin/entrypoint.sh 
RUN chmod uga+w /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
