class Survivor < ApplicationRecord

  enum gender: {male: true, female: false}
end
