iPhone helpers
============

Rails plugin providing helpers used to generate iPhone specific html tags.

Examples
=======

### viewport

    <%= iphone :viewport %>

### viewport with custom attributes

    <%= iphone :viewport, :width => 320, :height => 480, :initial_scale => 2.5, :minimum_scale => 0.5, :maximum_scale => 3, :user_scalable => 'no' %>

### apple touch icon

    <%= iphone :icon, :href => "iphone.png" %>

### apple touch icon precomposed

    <%= iphone :icon, :href => "iphone.png", :precomposed => true %>

### apple touch startup image

    <%= iphone :splash, :href => "splash.png" %>

### apple mobile web app status bar style

    <%= iphone :status_bar %>

### apple mobile web app status bar style black

    <%= iphone :status_bar, :color => "black" %>

### apple mobile web app status bar style black translucent

    <%= iphone :status_bar, :color => "black-translucent" %>

### disable telephone format detection

    <%= iphone :format_detection, :telephone => false %>

### enable telephone format detection

    <%= iphone :format_detection, :telephone => true %>

Install
=======

### Standard install using Rails 3.0.x

    rails plugin install git@github.com:mptre/rails-iphone-helpers.git

### Install using Git submodule

Run the following command from your Rails root directory.

    git submodule add git@github.com:mptre/rails-iphone-helpers.git vendor/plugins/iphone_helpers

You should be able to update this plugin in the future by running the following command from your Rails root directory.

    git submodule update

License
=======

Copyright (c) 2010 [Anton Lindqvist](http://qvister.se), released under the MIT license.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
