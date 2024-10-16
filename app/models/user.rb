class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  PASSWORD_REQUERIMENTS = /\A
    (?=.{8,})                     # Must contain minimum 8 chars of length 
    (?=.*\d)                      # Must contain at least one number
    (?=.*[a-z])                   # Must contain at least one lowercase letter
    (?=.*[A-Z])                   # Must contain at least one uppercase letter
    (?=.*[[:^alnum:]])            # Must contain at least one symbol
  /x

  AVAILABLE_QUESTIONS = [
    "¿Cuál es el nombre de su primera mascota?",
    "¿Cuál es el segundo nombre de su madre?",
    "¿En qué ciudad nació usted?",
    "¿En qué año termino su carrera?",
    "¿Quién es su profesor de seminario favorito?"
  ]

  has_secure_password

  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: EMAIL_REGEX }

  validates :security_question, presence: true
  validates :security_question, inclusion: { in: AVAILABLE_QUESTIONS }

  validates :security_answer, presence: true

  validates :password,
            format: PASSWORD_REQUERIMENTS,
            if: -> { new_record? || !password.nil? }
end