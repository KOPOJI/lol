#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'green_shoes'


# are the values ​​in the text fields numbers?
def check_int?(comment, objects = {})
  # if some attributes is nil
  return false if objects[:num_1].nil? || objects[:num_2].nil? || comment.nil?

  if objects[:num_1].text =~ /\A\d+?\z/ && objects[:num_2].text =~ /\A\d+?\z/
    comment.text = 'OK'
    true
  else
    comment.text = 'Введено неверное значение'
    false
  end
end

# lock the buttons from pressing them
def lock_buttons(*buttons)
  buttons.map! do |btn|
    btn.state = "disabled"
  end
end

# unlock the buttons
def unlock_buttons(*buttons)
  buttons.map! do |btn|
    btn.state = nil
  end
end


# create GUI with Shoes :)
Shoes.app width: 320, height: 350, title: 'Форма 1' do

  # first layer
  stack :margin => 30 do

    # some else layer)
    stack :margin => 10 do
      para "ФИО"
      @fio = edit_line
    end

    # some else layer)
    stack :margin => 10 do
      para "Номер группы"
      @group_number = edit_line
    end

    # some else layer)
    stack do
      para "Сейчас"
      # output current date and time with timer
      @time = para Time.now.strftime("%d.%m.%Y            %H:%M:%S")
      animate 1 do
        @time.text = Time.now.strftime("%d.%m.%Y            %H:%M:%S")
      end
    end

    # some else layer)
    stack do

      # first button
      button "Старт" do

        # create new form
        Shoes.app width: 500, height: 500 do
          # some layer)
          stack do

            # first edit
            @num_1 = edit_line do
              # check value on key press
              unless check_int? @comment, num_1: @num_1, num_2: @num_2
                lock_buttons @plus, @minus, @multiplication, @division
              else
                unlock_buttons @plus, @minus, @multiplication, @division
              end
            end

            # second edit
            @num_2 = edit_line do
              # check value on key press
              unless check_int? @comment, num_1: @num_1, num_2: @num_2
                lock_buttons @plus, @minus, @multiplication, @division
              else
                unlock_buttons @plus, @minus, @multiplication, @division
              end
            end

            # comment label for status text
            @comment = para "Комментарий"

            # command layer
            stack do
              para "Команды"

              # math buttons. On click values from edit inputs ​​are checked and expressions are executed if everything is OK

              # plus
              @plus = button "+", state: "disabled" do
                @result.text = (@num_1.text.to_i + @num_2.text.to_i).to_s
                @list_of_results.text += "#{@num_1.text} + #{@num_2.text} = #{@result.text}\n"
              end

              # minus
              @minus = button "-", state: "disabled" do
                @result.text = (@num_1.text.to_i - @num_2.text.to_i).to_s
                @list_of_results.text += "#{@num_1.text} - #{@num_2.text} = #{@result.text}\n"
              end

              # multiplication
              @multiplication = button "*", state: "disabled" do
                @result.text = (@num_1.text.to_i * @num_2.text.to_i).to_s
                @list_of_results.text += "#{@num_1.text} * #{@num_2.text} = #{@result.text}\n"
              end

              # division Value 2 couldn't be a zero
              @division = button "/", state: "disabled" do
                unless @num_2.text.to_i == 0
                  @result.text = (@num_1.text.to_i / @num_2.text.to_i).to_s
                  @list_of_results.text += "#{@num_1.text} / #{@num_2.text} = #{@result.text}\n"
                else
                  alert "Ошибка: деление на ноль"
                  @result.text = "0"
                  @list_of_results.text += "#{@num_1.text} / #{@num_2.text} - Ошибка: деление на ноль\n"
                end
              end

              # some function..
              @function = button "Функция" do
                #TODO: write function...
              end

              # reset edit values
              @c = button "C" do
                @num_1.text = @num_2.text = @result.text = "0"
              end

            end # end stack

            #result fields
            stack do
              para "Результат"
              @result = edit_line
              @list_of_results = edit_box scroll: true, width: 300
            end

          end # end stack

        end # end created Sub App

      end # end Button "Start"

      # exit from application
      button "Выход" do
        exit 0
      end

    end # end stack

  end # end stack

end # end App