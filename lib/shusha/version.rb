module Shusha
  module VERSION
    MAJOR = 0
    MINOR = 0
    TINY  = 3
    RC    = 0

    if RC > 0
      ARRAY = [MAJOR, MINOR, TINY, "rc#{RC}"]
    else
      ARRAY = [MAJOR, MINOR, TINY]
    end
    STRING = ARRAY.join('.')
  end
end
