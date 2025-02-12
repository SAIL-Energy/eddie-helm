FROM nginx:alpine

ENV EDDIE_CORE_URL http://localhost:8080
COPY index.html /usr/share/nginx/html/index.html
CMD sh -c "sed -i 's|EDDIE_CORE_URL|${EDDIE_CORE_URL}|g' /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"

EXPOSE 80