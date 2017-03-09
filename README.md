# jekyll-responsive-image

A [Jekyll](http://jekyllrb.com/) plugin and utility for automatically resizing images. Its intended use is for sites which want to display responsive images using something like [`srcset`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Img#Specifications) or [Imager.js](https://github.com/BBC-News/Imager.js/).

[![Build Status](https://img.shields.io/travis/wildlyinaccurate/jekyll-responsive-image.svg?style=flat-square)](https://travis-ci.org/wildlyinaccurate/jekyll-responsive-image)
[![Coverage Status](https://img.shields.io/coveralls/wildlyinaccurate/jekyll-responsive-image.svg?style=flat-square)](https://coveralls.io/repos/github/wildlyinaccurate/jekyll-responsive-image/badge.svg?branch=master)
[![Dependency Status](https://img.shields.io/gemnasium/wildlyinaccurate/jekyll-responsive-images.svg?style=flat-square)](https://gemnasium.com/wildlyinaccurate/jekyll-responsive-images)

## Installation

First, install the gem:

```
$ gem install jekyll-responsive-image
```

Then you can either add it to the `gems` section of your `_config.yml`:

```yaml
gems:
  - jekyll-responsive-image
```

Or you can copy the contents of [`responsive_image.rb`](lib/jekyll-responsive-image.rb) into your `_plugins` directory.

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
  
  # [Optional, Default: false]
  # Rotate resized images depending on their EXIF rotation attribute. Useful for
  # working with JPGs directly from digital cameras and smartphones
  respect_exif_rotation: false

  # [Optional, Default: assets]
  # The base directory where assets are stored. This is used to determine the
  # `dirname` value in `output_path_format` below.
  base_path: assets

  # [Optional, Default: assets/resized/%{filename}-%{width}x%{height}.%{extension}]
  # The template used when generating filenames for resized images. Must be a
  # relative path.
  #
  # Parameters available are:
  #   %{dirname}     Directory of the file relative to `base_path` (assets/sub/dir/some-file.jpg => sub/dir)
  #   %{basename}    Basename of the file (assets/some-file.jpg => some-file.jpg)
  #   %{filename}    Basename without the extension (assets/some-file.jpg => some-file)
  #   %{extension}   Extension of the file (assets/some-file.jpg => jpg)
  #   %{width}       Width of the resized image
  #   %{height}      Height of the resized image
  #
  output_path_format: assets/resized/%{width}/%{basename}

  # [Optional, Default: []]
  # By default, only images referenced by the responsive_image and responsive_image_block
  # tags are resized. Here you can set a list of paths or path globs to resize other
  # images. This is useful for resizing images which will be referenced from stylesheets.
  extra_images:
    - assets/foo/bar.png
    - assets/bgs/*.png
    - assets/avatars/*.{jpeg,jpg}
```

## Usage

Replace your images with the `responsive_image` tag, specifying the path to the image in the `path` attribute.

```twig
{% responsive_image path: assets/my-file.jpg %}
```

You can override the template on a per-image basis by specifying the `template` attribute.

```twig
{% responsive_image path: assets/my-file.jpg template: _includes/another-template.html %}
```

Any extra attributes will be passed straight to the template as variables.

```twig
{% responsive_image path: assets/image.jpg alt: "Lorem ipsum..." title: "Lorem ipsum..." %}
```

### Liquid variables as attributes

You can use Liquid variables as attributes with the `responsive_image_block` tag. This tag works in exactly the same way as the `responsive_image` tag, but is implemented as a block tag to allow for more complex logic.

> **Important!** The attributes in the `responsive_image_block` tag are parsed as YAML, so whitespace and indentation are significant!

```twig
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

#### Responsive images with `srcset`

```twig
{% capture srcset %}
    {% for i in resized %}
        /{{ i.path }} {{ i.width }}w,
    {% endfor %}
{% endcapture %}

<img src="/{{ path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }} /{{ original.path }} {{ original.width }}w">
```

#### Responsive image with `srcset` where the largest resized image is the default

> **Note:** This is useful if you don't want your originals to appear on your site. For example, if you're uploading full-res images directly from a device.
 
```twig
{% capture srcset %}
    {% for i in resized %}
        /{{ i.path }} {{ i.width }}w,
    {% endfor %}
{% endcapture %}

{% assign largest = resized | sort: 'width' | last %}

<img src="/{{ largest.path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }} /{{ original.path }} {{ original.width }}w">
```

#### Responsive images with `<picture>`

```twig
<picture>
    {% for i in resized %}
        <source media="(min-width: {{ i.width }}px)" srcset="/{{ i.path }}">
    {% endfor %}
    <img src="/{{ path }}">
</picture>
```

#### Responsive images using [Imager.js](https://github.com/BBC-News/Imager.js/)

> **Note:** This template assumes an `output_path_format` of `assets/resized/%{width}/%{basename}`

```twig
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

| Variable    | Type    | Description                                                                                  |
|-------------|---------|----------------------------------------------------------------------------------------------|
| `path`      | String  | The path to the image.                                                                       |
| `width`     | Integer | The width of the image.                                                                      |
| `height`    | Integer | The height of the image.                                                                     |
| `basename`  | String  | Basename of the file (`assets/some-file.jpg` => `some-file.jpg`).                            |
| `dirname`   | String  | Directory of the file relative to `base_path` (`assets/sub/dir/some-file.jpg` => `sub/dir`). |
| `filename`  | String  | Basename without the extension (`assets/some-file.jpg` => `some-file`).                      |
| `extension` | String  | Extension of the file (`assets/some-file.jpg` => `jpg`).                                     |
