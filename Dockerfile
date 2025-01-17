FROM php:7.4-apache

WORKDIR /var/www/html


RUN docker-php-ext-install mysqli

RUN a2enmod rewrite

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]
