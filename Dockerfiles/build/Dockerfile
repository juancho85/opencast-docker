# Copyright 2016 The WWU eLectures Team All rights reserved.
#
# Licensed under the Educational Community License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM fedora:25
LABEL maintainer="WWU eLectures team <electures.dev@uni-muenster.de>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.version="2.3.3" \
      org.label-schema.name="opencast-build" \
      org.label-schema.description="Image that provides an Opencast build and development environment" \
      org.label-schema.usage="https://github.com/opencast/opencast-docker/blob/2.3.3/README.md" \
      org.label-schema.url="http://www.opencast.org/" \
      org.label-schema.vcs-url="https://github.com/opencast/opencast-docker" \
      org.label-schema.vendor="University of Münster" \
      org.label-schema.docker.debug="docker exec -it $CONTAINER bash"

ARG repo="https://bitbucket.org/opencast-community/matterhorn.git"
ARG branch="2.3.3"

ENV OPENCAST_VERSION="2.3.3" \
    OPENCAST_SRC="/usr/src/opencast" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_DATA="/data" \
    OPENCAST_CUSTOM_CONFIG="/etc/opencast" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    \
    TESSERACT_BASE_URL="https://github.com/tesseract-ocr/tessdata/raw/3cf1e2df1fe1d1da29295c9ef0983796c7958b7d" \
    HUNSPELL_BASE_URL="http://download.services.openoffice.org/contrib/dictionaries" \
    \
    ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER="admin" \
    ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS="opencast" \
    ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER="opencast_system_account" \
    ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS="CHANGE_ME" \
    OPENCAST_BUILD_ASSETS="/docker"
ENV OPENCAST_SCRIPTS="${OPENCAST_HOME}/docker/scripts" \
    OPENCAST_SUPPORT="${OPENCAST_HOME}/docker/support" \
    OPENCAST_CONFIG="${OPENCAST_HOME}/etc" \
    OPENCAST_REPO="${repo}" \
    OPENCAST_BRANCH="${branch}"

RUN dnf -y install \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
  \
  # Build deps
 && dnf -y install \
      sudo \
      tar gzip bzip2 unzip \
      git wget \
      make automake gcc gcc-c++ \
      maven \
      python \
  \
  # Run deps
 && dnf -y install \
      java-1.8.0-openjdk \
      openssl tzdata curl nc \
      fontconfig dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts \
      gnu-free-serif-fonts gnu-free-mono-fonts gnu-free-sans-fonts \
      liberation-fonts linux-libertine-fonts \
      ffmpeg \
      sox \
      hunspell \
      tesseract \
  \
 && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
 && cd /tmp/su-exec \
 && make \
 && cp su-exec /usr/local/sbin \
  \
  # Install languag files for tesseract and hunspell
 && mkdir -p /tmp/tesseract /tmp/hunspell /usr/share/tessdata /usr/share/hunspell \
 && { \
      echo "59d92b49a22ff96964ba7be053a9e7198cd14c88f76788e7ce2555f5acb9a40c  deu.traineddata"; \
      echo "1cb1468826191cc7d4158fe0a3014d3f5e3bbac618d754586afc86ddae8bcdae  eng.traineddata"; \
    } > /tmp/tesseract-sha256sum.txt \
 && cd /tmp/tesseract \
 && for file in $(awk '{print $2}' /tmp/tesseract-sha256sum.txt); do \
      wget -O "${file}" "${TESSERACT_BASE_URL}/${file}"; \
      grep "${file}" /tmp/tesseract-sha256sum.txt | sha256sum -c -; \
      cp "${file}" /usr/share/tessdata; \
    done \
 && { \
      echo "2478723ab67dd801ec6add11b1af9d32665e7859a1cb00c95bfc2b618584a802  de_AT.zip"; \
      echo "c30bb085ba0a3d22a23aef51f4dd94ae9ae0cc811c0590ebf3713a93b209d823  de_CH.zip"; \
      echo "220e01c3137000305247336d8d10cd550bda3990fb10e50b31633947969a34b8  de_DE_comb.zip"; \
      echo "22e217a631977d7b377f8dd22d2bbacd2d36b32765ce13f3474b03a4a97dd700  en_AU.zip"; \
      echo "31fac12a1b520cde686f328d3fa7560f6eba772cddc872197ff842c57a0dc1ea  en_CA.zip"; \
      echo "5869d8bd80eb2eb328ebe36b356348de4ae2acb1db6df39d1717d33f89f63728  en_GB.zip"; \
      echo "6cc717b4de43240595662a2deef5447b06062e82380f5647196f07c9089284fa  en_NZ.zip"; \
      echo "9227f658f182c9cece797352f041a888134765c11bffc91951c010a73187baea  en_US.zip"; \
      echo "090285b721dcaabff51b467123f82a181a6904d187c90bda812c6e5f365ff19a  en_ZA.zip"; \
    } > /tmp/hunspell-sha256sum.txt \
 && cd /tmp/hunspell \
 && for file in $(awk '{print $2}' /tmp/hunspell-sha256sum.txt); do \
      wget -O "${file}" "${HUNSPELL_BASE_URL}/${file}"; \
      grep "${file}" /tmp/hunspell-sha256sum.txt | sha256sum -c -; \
      unzip "/tmp/hunspell/${file}"; \
    done \
 && cp *.aff *.dic /usr/share/hunspell \
 && groupadd --system -g "${OPENCAST_GID}" "${OPENCAST_GROUP}" \
 && useradd --system -M -N -g "${OPENCAST_GROUP}" -d "${OPENCAST_HOME}" -u "${OPENCAST_UID}" "${OPENCAST_USER}" \
 && mkdir -p "${OPENCAST_SRC}" "${OPENCAST_HOME}" "${OPENCAST_DATA}" "${OPENCAST_BUILD_ASSETS}" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" "${OPENCAST_DATA}" \
 && echo "opencast-builder ALL = NOPASSWD: ALL" > /etc/sudoers.d/opencast-builder \
  \
  # Cleanup
 && rm -rf /tmp/* /var/cache/dnf /var/log/dnf* /var/log/hawkey.log

COPY assets/docker-entrypoint.sh /docker-entrypoint.sh
COPY assets/build "${OPENCAST_BUILD_ASSETS}/"
COPY assets/bin/* "/usr/local/bin/"

WORKDIR "${OPENCAST_SRC}"

EXPOSE 8080 5005
VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_SRC}", "/root/.m2" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]
