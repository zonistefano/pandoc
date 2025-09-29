FROM pandoc/latex:3.2.1-alpine

RUN tlmgr install \
    adjustbox \
    background \
    draftwatermark \
    fvextra \
    lastpage \
    mdframed \
    pagecolor \
    sourcecodepro \
    sourcesanspro \
    svg \
    amsmath \
    iftex \
    xcolor \
    upquote \
    microtype \
    geometry \
    setspace \
    float \
    booktabs \
    etoolbox \
    ly1 \
    lineno \
    everypage \
    zref \
    needspace \
    footnotehyper \
    listings \
    luacolor \
    lua-ul \
    soul \
    babel \
    selnolig \
    bookmark \
    xurl \
    caption
    
RUN apk add npm chromium font-noto-cjk font-noto-emoji \
terminus-font ttf-dejavu ttf-freefont ttf-font-awesome \
ttf-inconsolata ttf-linux-libertine \
&& fc-cache -f

RUN npm install --global mermaid-filter

RUN echo '{"args": ["--no-sandbox","--disable-setuid-sandbox"],"executablePath": "/usr/bin/chromium-browser"}' > /tmp/.puppeteer.json

ENV MERMAID_FILTER_PUPPETEER_CONFIG="/tmp/.puppeteer.json"

ENV PUPPETEER_SKIP_DOWNLOAD="true" \
    PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium-browser"

# Override the ENTRYPOINT to use a shell
#ENTRYPOINT ["/bin/sh", "-c"]

# Now, use CMD to provide the command to keep the container alive.
#CMD ["sleep infinity"]