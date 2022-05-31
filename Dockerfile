FROM ruby:2.6.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client git curl zsh dialog apt-utils ripgrep
WORKDIR /workspaces/devcontainer

# RAILS_ENV
# ENV RAILS_ENV="devcontainer"

# GEMFILE
# COPY Gemfile /workspaces/devcontainer/Gemfile
# COPY Gemfile.lock /workspaces/devcontainer/Gemfile.lock

# BUNDLER
# ENV GEM_HOME="/usr/local/bundle"
# ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
# RUN \
#   gem update --system --quiet && \
#   gem install  bundler -v '~> 1.17.3'
# ENV BUNDLER_VERSION 1.17.3
# RUN bundle install

# ZSH
RUN chsh -s $(which zsh)
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# NEOVIM

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN mv ./nvim.appimage /usr/bin/
# RUN alias vim="/usr/bin/nvim.appimage --appimage-extract-and-run" # Add this to your .zshrc
RUN echo '\nalias vim="/usr/bin/nvim.appimage --appimage-extract-and-run"' >> ~/.zshrc

# SSH
# RUN eval "$(ssh-agent -s)"
# RUN exec ssh-agent zsh
# RUN  echo "    IdentityFile ~/.ssh/devcontainer" >> /etc/ssh/ssh_config
# RUN ssh-add ~/.ssh/devcontainer
# RUN ssh -o StrictHostKeyChecking=no git@github.com
# RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# DOTFILES
# RUN --mount=type=ssh git clone -q git@github.com:MarcellMC/.config ~/.config
RUN git clone -q https://github.com/MarcellMC/.config.git ~/.config
# RUN git remote set-url origin git@github.com:MarcellMC/.config

# NEOVIM PACKER
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.config/nvim/site/pack/packer/start/packer.nvim
# RUN vim --headless +PackerCompile +PackerSync +qa >> /dev/null
# RUN vim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
# RUN dpkg -i ripgrep_13.0.0_amd64.deb

COPY . /workspaces/devcontainer
# Don't forget to install plugins
# RUN cp .devcontainer/nvim ~/.config/nvim
# RUN cp .devcontainer/zsh/.zshrc ~

# Entrypoint script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD zsh
