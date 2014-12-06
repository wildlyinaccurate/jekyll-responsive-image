# Jekyll Responsive Images

Jekyll Responsive Images is a [Jekyll](http://jekyllrb.com/) plugin and utility for automatically resizing images. Its intended use is for sites which want to display responsive images using something like [`srcset`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Img#Specifications) or [Imager.js](https://github.com/BBC-News/Imager.js/).

[![Build Status](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-images.svg?branch=master)](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-images)
[![Coverage Status](https://img.shields.io/coveralls/wildlyinaccurate/jekyll-responsive-images.svg)](https://coveralls.io/r/wildlyinaccurate/jekyll-responsive-images)
[![Dependency Status](https://gemnasium.com/wildlyinaccurate/jekyll-responsive-images.svg)](https://gemnasium.com/wildlyinaccurate/jekyll-responsive-images)

## Installation

Install the gem yourself

```
$ gem install jekyll-responsive-image
```

Or simply add it to your Jekyll `_config.yml`:

```yaml
gems: [jekyll-responsive-image]
```

## Configuration

An example configuration is below.

```yaml
responsive_image:
  template: '_includes/responsive-image.html' # Path to the template to render. Required.

  # An array of resize configurations. When this array is empty (or not specified),
  # no resizing will take place.
  sizes:
    - width: 480 # How wide the resized image will be. Required
    - width: 800
      quality: 90 # JPEG quality. Optional.
    - width: 1400
```

## Usage

Replace your images with the `responsive_image` tag, specifying a path to the image.

```
{% responsive_image path: assets/my-file.jpg %}
```

Any extra attributes will be passed to the template.

```
{% responsive_image path: assets/image.jpg alt: "Lorem ipsum..." title: "Lorem ipsum..." %}
```

Create a template to suit your needs. A basic template example is below.

```html
<img src="/{{ path }}"
     alt="{{ alt }}"
     title="{{ title }}

     {% if resized %}
         srcset="{% for i in resized %}
             /{{ i.path }} {{ i.width }}w{% if forloop.last == false %},{% endif %}
         {% endfor %}"
     {% endif %}
>
```
