require_relative 'element_matcher'

class Metallize::Page

  extend Metallize::ElementMatcher

  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def title
    driver.title
  end

  def uri
    URI(driver.current_url)
  end

  def links
    @links ||= driver.find_elements(:tag_name, 'a').map do |link|
      Link.new(driver, link)
    end
  end

  def forms
    forms = driver.find_elements(:tag_name, 'form')
    forms.map {|form| Metallize::Form.new(driver, form)}
  end

  def at(args)
    if args.kind_of?(String)
      driver.find_element(css: args)
    else
      driver.find_element(args)
    end
  end

  def pretty_print(q)
    q.object_group(self) {
      q.breakable
      q.group(1, '{url', '}') {q.breakable; q.pp uri }
      q.breakable
      # q.group(1, '{meta_refresh', '}') {
      #   meta_refresh.each { |link| q.breakable; q.pp link }
      # }
      # q.breakable
      q.group(1, '{title', '}') { q.breakable; q.pp title }
      q.breakable
      # q.group(1, '{iframes', '}') {
      #   iframes.each { |link| q.breakable; q.pp link }
      # }
      # q.breakable
      # q.group(1, '{frames', '}') {
      #   frames.each { |link| q.breakable; q.pp link }
      # }
      # q.breakable
      q.group(1, '{links', '}') {
        links.each { |link| q.breakable; q.pp link }
      }
      # q.breakable
      q.group(1, '{forms', '}') {
        forms.each { |form| q.breakable; q.pp form }
      }
    }
  end

  elements_with :link

  elements_with :form

end
