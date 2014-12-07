# Jekyll Responsive Images

Jekyll Responsive Images is a [Jekyll](http://jekyllrb.com/) plugin and utility for automatically resizing images. Its intended use is for sites which want to display responsive images using something like [`srcset`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Img#Specifications) or [Imager.js](https://github.com/BBC-News/Imager.js/).

[![Build Status](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-images.svg?branch=master)](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-images)
[![Coverage Status](https://img.shields.io/coveralls/wildlyinaccurate/jekyll-responsive-images.svg)](https://coveralls.io/r/wildlyinaccurate/jekyll-responsive-images)
[![Dependency Status](https://gemnasium.com/wildlyinaccurate/jekyll-responsive-images.svg)](https://gemnasium.com/wildlyinaccurate/jekyll-responsive-images)

## Installation

You can either use the gem and update your `_config.yml`:

```
$ gem install jekyll-responsive_image
```

```yaml
# _config.yml
gems: [jekyll-responsive_image]
```

Or you can simply copy [`responsive_image.rb`](lib/jekyll/responsive_image.rb) into your `_plugins` directory.

## Configuration

An example configuration is below.

```yaml
responsive_image:
  # [Required]
  # Path to the image template.
  template: _includes/responsive-image.html

  # [Optional, Default: 85]
  # Quality to use when resizing images.
  default_quality: 90

  # [Optional, Default: []]
  # An array of resize configuration objects. Each object must contain at least
  # a `width` value.
  sizes:
    - width: 480  # [Required] How wide the resized image will be.
      quality: 80 # [Optional] Overrides default_quality for this size.
    - width: 800
    - width: 1400
      quality: 90

  # [Optional, Default: assets/resized/%{filename}-%{width}x%{height}.%{extension}]
  # The template used when generating filenames for resized images.
  #
  # Parameters available are:
  #   %{basename}    Basename of the file (assets/some-file.jpg => some-file.jpg)
  #   %{filename}    Basename without the extension (assets/some-file.jpg => some-file)
  #   %{extension}   Extension of the file (assets/some-file.jpg => jpg)
  #   %{width}       Width of the resized image
  #   %{height}      Height of the resized image
  #
  output_path_format: assets/resized/%{width}/%{basename}
```

## Usage

Replace your images with the `responsive_image` tag, specifying the path to the image in the `path` attribute.

```
{% responsive_image path: assets/my-file.jpg %}
```

You can override the template on a per-image basis by specifying the `template` attribute.

```
{% responsive_image path: assets/my-file.jpg template: _includes/another-template.html %}
```

Any extra attributes will be passed straight to the template as variables.

```
{% responsive_image path: assets/image.jpg alt: "Lorem ipsum..." title: "Lorem ipsum..." %}
```

### Liquid variables as attributes

You can use Liquid variables as attributes with the `responsive_image_block` tag. This tag works in exactly the same way as the `responsive_image` tag, but is implemented as a block tag to allow for more complex logic.

> **Important!** The attributes in the `responsive_image_block` tag are parsed as YAML, so whitespace and indentation are important!

```
{% assign path = 'assets/test.png' %}
{% assign alt = 'Lorem ipsum...' %}

{% responsive_image_block %}
    path: {{ path }}
    alt: {{ alt }}
    {% if title %}
    title: {{ title }}
    {% endif %}
{% endresponsive_image_block %}
```

### Template

You will need to create a template in order to use the `responsive_image` tag. Below are some sample templates to get you started.

#### Basic image tag with `srcset`

```html
<img src="/{{ path }}"
     srcset="
      {% for i in resized %}/{{ i.path }} {{ i.width }}w,{% endfor %}
      /{{ original.path }} {{ original.width }}w
     ">
```

#### Responsive images using [Imager.js](https://github.com/BBC-News/Imager.js/)

> This template assumes an `output_path_format` of `assets/resized/%{width}/%{basename}`

```html
{% assign smallest = resized | sort: 'width' | first %}

<div class="responsive-image">
    <img class="responsive-image__placeholder" src="/{{ smallest.path }}">
    <div class="responsive-image__delayed" data-src="/assets/resized/{width}/{{ original.basename }}"></div>
</div>

<script>
    new Imager('.responsive-image__delayed', {
        availableWidths: [{{ resized | map: 'width' | join: ', ' }}]
        onImagesReplaced: function() {
            $('.responsive-image__placeholder').hide();
        }
    });
</script>
```

### Template Variables

The following variables are available in the template:

| Variable   | Type   | Description                                                                                          |
|----------- |--------|------------------------------------------------------------------------------------------------------|
| `path`     | String | The path of the unmodified image. This is always the same as the `path` attribute passed to the tag. |
| `resized`  | Array  | An array of all the resized images. Each image is an **Image Object**.                               |
| `original` | Object | An **Image Object** containing information about the original image.                                 |
| `*`        | String | Any other attributes will be passed to the template verbatim as strings.                             |

#### Image Objects

Image objects (like `original` and each object in `resized`) contain the following properties:

| Variable    | Type    | Description                                                             |
|-------------|---------|-------------------------------------------------------------------------|
| `path`      | String  | The path to the image.                                                  |
| `width`     | Integer | The width of the image.                                                 |
| `height`    | Integer | The height of the image.                                                |
| `basename`  | String  | Basename of the file (`assets/some-file.jpg` => `some-file.jpg`).       |
| `filename`  | String  | Basename without the extension (`assets/some-file.jpg` => `some-file`). |
| `extension` | String  | Extension of the file (`assets/some-file.jpg` => `jpg`).                |
