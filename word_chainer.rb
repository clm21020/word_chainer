require 'set'
require 'byebug'

class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = file_to_set(dictionary_file_name)
  end

  def file_to_set(file_name)
    words = File.readlines(file_name).map(&:chomp)
    Set.new(words)
  end

  def adjacent_words(word)
    results = []
    same_length_words = @dictionary.dup.select! do |other_word|
      word.length == other_word.length
    end

    word.length.times do |i|
      ('a'..'z').each do |c|
        new_word = change_word(word, i, c)
        results << new_word if same_length_words.include?(new_word)
      end
    end

    results
  end

  def change_word(word, i, c)
    new_word = word.dup
    new_word[i] = c
    new_word
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}

    #until @current_words.empty?
    2.times do
      explore_current_words
    end

  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |word|
      adjacent_words(word).each do |near_word|
        next if @all_seen_words.include?(near_word)
        new_current_words << near_word
        @all_seen_words[near_word] = word
      end
    end

    p @all_seen_words
    @current_words = new_current_words
  end

  def build_path(target)
    path = [target]
    prior = target.dup
    until prior.nil?
      prior = @all_seen_words[prior]
      path << prior

    end
  end
end
