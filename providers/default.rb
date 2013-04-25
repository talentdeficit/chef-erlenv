# The MIT License (MIT)

# Copyright (c) 2013 alisdair sullivan <alisdairsullivan@yahoo.ca>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


def whyrun_supported?
  true
end

action :create do
  if ::File.directory? "/home/#{new_resource.user}/.erlenv/bin"
    Chef::Log.info "#{new_resource} already exists"
  else
    converge_by("Create erlenv") do
      git "erlenv" do
        repository new_resource.git_repo
        reference new_resource.version
        destination "/home/#{new_resource.user}/.erlenv"
        user new_resource.user
        group "admin"
        action :sync
      end

      file "etc/profile.d/erlenv.sh" do
        owner new_resource.user
        group "admin"
        content <<-EOS
    # prepend .erlenv/bin to path if it exists and init erlenv

    if [ -d "${HOME}/.erlenv/bin" ]; then
      export PATH="${HOME}/.erlenv/bin:$PATH"
      eval "$(erlenv init -)"
    fi
    EOS
      end
    end
  end
end

