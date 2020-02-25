
# File 'lib/selenium/webdriver/common/action_builder.rb', line 28

#def initialize(mouse, keyboard)
#  @devices    = {
#    :mouse    => mouse,
#    :keyboard => keyboard
#  }

#  @actions  = []
#end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 37

def key_down(*args)
  if args.first.kind_of? Element
    @actions << [:mouse, :click, [args.shift]]
  end

  @actions << [:keyboard, :press, args]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 46

def key_up(*args)
  if args.first.kind_of? Element
    @actions << [:mouse, :click, [args.shift]]
  end

  @actions << [:keyboard, :release, args]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 55

def send_keys(*args)
  if args.first.kind_of? Element
    @actions << [:mouse, :click, [args.shift]]
  end

  @actions << [:keyboard, :send_keys, args]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 64

def click_and_hold(element)
  @actions << [:mouse, :down, [element]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 69

def release(element = nil)
  @actions << [:mouse, :up, [element]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 74

def click(element = nil)
  @actions << [:mouse, :click, [element]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 79

def double_click(element = nil)
  @actions << [:mouse, :double_click, [element]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 84

def move_to(element, right_by = nil, down_by = nil)
  if right_by && down_by
    @actions << [:mouse, :move_to, [element, right_by, down_by]]
  else
    @actions << [:mouse, :move_to, [element]]
  end

  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 94

def move_by(right_by, down_by)
  @actions << [:mouse, :move_by, [right_by, down_by]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 99

def context_click(element = nil)
  @actions << [:mouse, :context_click, [element]]
  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 104

def drag_and_drop(source, target)
  click_and_hold source
  move_to        target
  release        target

  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 112

def drag_and_drop_by(source, right_by, down_by)
  click_and_hold source
  move_by        right_by, down_by
  release

  self
end

# File 'lib/selenium/webdriver/common/action_builder.rb', line 120

def perform
  @actions.each { |receiver, method, args|
    @devices.fetch(receiver).__send__(method, *args)
  }
end