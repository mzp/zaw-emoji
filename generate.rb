require 'time'
require 'bundler'
Bundler.require

Entry = Struct.new(:name, :raw) do
  def <=>(that)
    name <=> that.name
  end
end

entries = Emoji.all.flat_map do |emoji|
  emoji.aliases.map do |name|
    Entry.new(name, emoji.raw)
  end
end

entries.sort!

gemoji_version = Bundler.load.specs.find do |spec|
  spec.name == 'gemoji'
end.version.to_s

emojis = entries.map do |entry|
  "'#{entry.name}' '#{entry.raw}'"
end.join("\n")


puts <<-END
#
# zaw-src-emoji
#

function zaw-src-emoji() {
  local -A emoji
  emoji=(#{emojis})

  candidates=()

  for key in "${(@k)emoji}"; do
    candidates+=("${emoji[$key]}  $key")
  done

  actions=("zaw-callback-append-symbol-to-buffer")

  act_descriptions=("append to edit buffer")
}

function zaw-callback-append-symbol-to-buffer(){
  LBUFFER="${LBUFFER}:${1#*  }:"
}

zaw-register-src -n emoji zaw-src-emoji
END
