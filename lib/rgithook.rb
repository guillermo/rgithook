__DIR__ = File.dirname(__FILE__)

$:.unshift(__DIR__) unless
  $:.include?(__DIR__) || $:.include?(File.expand_path(__DIR__))

%w(version githook html).each { |f| require 'rgithook/'+f }

CONSTANTE="hola"



