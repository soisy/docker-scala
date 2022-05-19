FROM ubuntu:22.10

RUN apt update
RUN apt install -y ca-certificates curl
RUN apt install -y default-jdk

RUN export PATH="/root/.local/share/coursier/bin:${PATH}"

RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs
RUN chmod +x cs
RUN ./cs setup -y
RUN apt install -y gnupg2
RUN  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update
RUN apt-get install -y sbt
