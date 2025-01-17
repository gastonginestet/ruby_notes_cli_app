require 'commonmarker'
class Note
  def check_for_global_book
    if Dir.exist?("#{Dir.home}/.my_rns") == false
      puts '------------------------------------------------------------'
      puts 'No se detectó el cajón de notas.', :yellow
      puts 'Creando el cajon de notas de RN en la ubicación por defecto '
      puts "#{Dir.home}/.my_rns", :green
      puts '------------------------------------------------------------'
      Dir.mkdir("#{Dir.home}/.my_rns")
    end
  end

  def create(book, title)
    check_for_global_book
    if book.nil?
      create_global(title)
    else
      create_in_book(title, book)
    end
  end

  def create_global(title)
    file_path = "#{Dir.home}/.my_rns/#{title}.rn"
    if File.exist?(file_path)
      puts "Ya existe la nota con nombre #{title}", :red
    else
      puts "Creando nota con nombre #{title}"
      puts 'Abriendo editor..'
      editor = TTY::Editor.new
      editor.open(file_path)
      puts 'Imprimiendo contenido... con colores!'
      puts File.read(file_path), :rainbow
    end
  end

  def create_in_book(title, book)
    book_path = "#{Dir.home}/.my_rns/#{book}/"
    file_path = "#{Dir.home}/.my_rns/#{book}/#{title}.rn"
    if Dir.exist?(book_path)
      if File.exist?(file_path)
        puts "Ya existe la nota con nombre #{title}", :red
      else
        puts "Creando nota con nombre #{title}"
        puts 'Abriendo editor..'
        editor = TTY::Editor.new
        editor.open(file_path)
        puts 'Imprimiendo contenido... con colores!'
        puts File.read(file_path), :rainbow
      end
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def delete(book, title)
    check_for_global_book
    if book.nil?
      delete_in_global(title)
    else
      delete_in_book(book, title)
    end
  end

  def delete_in_global(title)
    prompt = TTY::Prompt.new
    file_path = "#{Dir.home}/.my_rns/#{title}.rn"
    if File.exist?(file_path)
      if prompt.yes?("Estas seguro que queres borrar la nota con nombre: '#{title}' en el cuaderno global?")
        puts "Borrando la nota con nombre: '#{title}' , en el cuaderno global ...."
        FileUtils.rm_f(file_path)
        puts 'Borrada!'
      end
    else
      puts "No existe la nota con nombre: '#{title}'", :red
    end
  end

  def delete_in_book(book, title)
    prompt = TTY::Prompt.new
    book_path = "#{Dir.home}/.my_rns/#{book}/"
    file_path = "#{Dir.home}/.my_rns/#{book}/#{title}.rn"
    if Dir.exist?(book_path)
      if File.exist?(file_path)
        if prompt.yes?("Estas seguro que queres borrar la nota con nombre: '#{title}' en el cuaderno global?")
          puts "Borrando la nota con nombre: '#{title}' , en el cuaderno: '#{book}' ...."
          FileUtils.rm_f(file_path)
          puts 'Borrada!'
        end
      else
        puts "No existe la nota con nombre: '#{title}' , en el cuaderno: '#{book}'", :red
      end
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def edit(book, title)
    check_for_global_book
    if book.nil?
      edit_in_global(title)
    else
      edit_in_book(book, title)
    end
  end

  def edit_in_global(title)
    file_path = "#{Dir.home}/.my_rns/#{title}.rn"
    if File.exist?(file_path)
      puts 'Abriendo editor..'
      editor = TTY::Editor.new
      editor.open(file_path)
      puts 'Imprimiendo contenido... con colores!'
      puts File.read(file_path), :rainbow
    else
      puts "No existe la nota con nombre: '#{title}'", :red
    end
  end

  def edit_in_book(book, title)
    book_path = "#{Dir.home}/.my_rns/#{book}/"
    file_path = "#{Dir.home}/.my_rns/#{book}/#{title}.rn"
    if Dir.exist?(book_path)
      if File.exist?(file_path)
        puts 'Abriendo editor..'
        editor = TTY::Editor.new
        editor.open(file_path)
        puts 'Imprimiendo contenido... con colores!'
        puts File.read(file_path), :rainbow
      end
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def retitle(book, _title)
    check_for_global_book
    if book.nil?
      retitle_in_global(old_title, new_title)
    else
      retitle_in_book(book, old_title, new_title)
    end
  end

  def retitle_in_global(old_title, new_title)
    file_path = "#{Dir.home}/.my_rns/#{old_title}.rn"
    if File.exist?(file_path)
      new_path = "#{Dir.home}/.my_rns/#{new_title}.rn"
      puts "Reenombrando nota con nombre: #{old_title} a #{new_title}.."
      File.rename file_path, new_path
      puts 'Listo!', :green
    else
      puts "No existe la nota con nombre: '#{old_title}'", :red
    end
  end

  def retitle_in_book(book, old_title, new_title)
    book_path = "#{Dir.home}/.my_rns/#{book}/"
    file_path = "#{Dir.home}/.my_rns/#{book}/#{old_title}.rn"
    if Dir.exist?(book_path)
      if File.exist?(file_path)
        new_path = "#{Dir.home}/.my_rns/#{book}/#{new_title}.rn"
        puts "Reenombrando nota con nombre: #{old_title} a #{new_title}.."
        File.rename file_path, new_path
        puts 'Listo!', :green
      else
        puts "No existe la nota con nombre: '#{old_title}'", :red
      end
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def list(book)
    check_for_global_book
    if book.nil?
      dir_path = "#{Dir.home}/.my_rns/"
      list_files_from(dir_path)
    else
      dir_path = "#{Dir.home}/.my_rns/#{book}/"
      if Dir.exist?(dir_path)
        list_files_from(dir_path)
      else
        puts "No existe cuaderno con nombre: '#{book}'", :red
      end
    end
  end

  def list_files_from(dir_path)
    Dir.each_child(dir_path) do |file|
      puts file.to_s if File.directory?("#{dir_path}/#{file}") == false
    end
  end

  def show(title, book)
    check_for_global_book
    if book.nil?
      file_path = "#{Dir.home}/.my_rns/#{title}.rn"
      if File.exist?(file_path)
        puts ' |Imprimiendo contenido de la nota| '
        puts '------------------------------------'
        puts File.read(file_path)
        puts '------------------------------------'
        puts "Ultima vez modificado: #{File.mtime(file_path)}"
      else
        puts "No existe la nota con nombre: '#{title}'", :red
      end
    else
      book_path = "#{Dir.home}/.my_rns/#{book}/"
      file_path = "#{Dir.home}/.my_rns/#{book}/#{title}.rn"
      if Dir.exist?(book_path)
        if File.exist?(file_path)
          puts ' |Imprimiendo contenido de la nota| '
          puts '------------------------------------'
          puts File.read(file_path)
          puts '------------------------------------'
          puts ' |             FIN                | '
        end
      else
        puts "No existe cuaderno con nombre: '#{book}'", :red
      end
    end
  end

  def export_files_from(dir_path)
    Dir.each_child(dir_path) do |file|
      next unless File.directory?("#{dir_path}/#{file}") == false
      name = File.basename("#{dir_path}/#{file}", '.*')
      file_data = File.read("#{dir_path}/#{file}")
      file_data = CommonMarker.render_html(file_data,:DEFAULT)
      new_exported_file = "#{Dir.home}/my_exported_notes/#{name}.html"
      File.write(new_exported_file, file_data)
    end
  end

  def export(all, global, title, book)
    if Dir.exist?("#{Dir.home}/.my_rns") == true
      if all
        export_all_notes
      elsif global
        if title.nil?
          export_all_notes_from_global
        else
          export_note_from_global(title)
        end
      elsif title.nil?
        export_all_notes_from_book(book)
      elsif book.nil?
        export_note_from_global(title)
      else
        export_note_from_book(title, book)
      end
    else
      puts 'No se detectó el cajón de notas.', :red
    end
  end

  def export_all_notes_from_global
    check_export_dir
    puts ' Exportando todas las notas en formato HTML del cuaderno global en: '
    puts " #{Dir.home}/my_exported_notes", :blue
    puts ' ------------------------------------------------------------------------ '
    dir_path = "#{Dir.home}/.my_rns"
    Dir.each_child(dir_path) do |file|
      next unless File.directory?("#{dir_path}/#{file}") == false

      name = File.basename("#{dir_path}/#{file}", '.*')
      file_data = File.read("#{dir_path}/#{file}")
      file_data = CommonMarker.render_html(file_data,:DEFAULT)
      new_exported_file = "#{Dir.home}/my_exported_notes/#{name}.html"
      File.write(new_exported_file, file_data)
    end
    bar = TTY::ProgressBar.new('exportando [:bar]', total: 30)
    30.times do
      sleep(0.1)
      bar.advance(1)
    end
    puts 'Listo!', :green
  end

  def export_all_notes
    check_export_dir
    puts ' Exportando todas las notas en formato HTML '
    puts ' esto puede demorar un poco.. '
    puts "destino: #{Dir.home}/my_exported_notes", :blue
    puts ' ------------------------------------------------------------------------ '
    dir_path = "#{Dir.home}/.my_rns"
    Dir.each_child(dir_path) do |file|
      if File.directory?("#{dir_path}/#{file}") == false
        name = File.basename("#{dir_path}/#{file}", '.*')
        file_data = File.read("#{dir_path}/#{file}")
        file_data = CommonMarker.render_html(file_data,:DEFAULT)
        new_exported_file = "#{Dir.home}/my_exported_notes/#{name}.html"
        File.write(new_exported_file, file_data)
      else
        export_files_from("#{dir_path}/#{file}")
      end
    end
    bar = TTY::ProgressBar.new('exportando [:bar]', total: 35)
    35.times do
      sleep(0.1)
      bar.advance(1)
    end
    puts 'Listo!', :green
  end

  def export_note_from_global(title)
    check_export_dir
    dir_path = "#{Dir.home}/.my_rns"
    file_path = "#{dir_path}/#{title}.rn"
    if File.exist?(file_path)
      puts " Exportando la nota '#{title}' en formato HTML del cuaderno global en: "
      puts " #{Dir.home}/my_exported_notes", :blue
      puts '  ------------------------------------------------------------------------- '
      file_data = File.read(file_path.to_s)
      file_data = CommonMarker.render_html(file_data,:DEFAULT)
      new_exported_file = "#{Dir.home}/my_exported_notes/#{title}.html"
      File.write(new_exported_file, file_data)
      bar = TTY::ProgressBar.new('exportando [:bar]', total: 10)
      10.times do
        sleep(0.1)
        bar.advance(1)
      end
      puts 'Listo!', :green
    else
      puts "No existe la nota con nombre: '#{title}' en el cuaderno global.", :red
    end
  end

  def export_all_notes_from_book(book)
    check_export_dir
    dir_path = "#{Dir.home}/.my_rns/#{book}"
    if Dir.exist?(dir_path)
      puts " Exportando todas las notas en formato HTML del cuaderno '#{book}' en: "
      puts " #{Dir.home}/my_exported_notes", :blue
      puts ' ------------------------------------------------------------------------ '
      Dir.each_child(dir_path) do |file|
        next unless File.directory?("#{dir_path}/#{file}") == false

        name = File.basename("#{dir_path}/#{file}", '.*')
        file_data = File.read("#{dir_path}/#{file}")
        file_data = CommonMarker.render_html(file_data,:DEFAULT)
        new_exported_file = "#{Dir.home}/my_exported_notes/#{name}.html"
        File.write(new_exported_file, file_data)
      end
      bar = TTY::ProgressBar.new('exportando [:bar]', total: 30)
      30.times do
        sleep(0.1)
        bar.advance(1)
      end
      puts 'Listo!', :green
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def export_note_from_book(title, book)
    check_export_dir
    book_path = "#{Dir.home}/.my_rns/#{book}"
    file_path = "#{book_path}/#{title}.rn"
    if Dir.exist?(book_path)
      if File.exist?(file_path)
        puts " Exportando la nota '#{title}' en formato HTML del cuaderno '#{book}' , en: "
        puts " #{Dir.home}/my_exported_notes", :blue
        puts '  ------------------------------------------------------------------------- '
        file_data = File.read(file_path.to_s)
        file_data = CommonMarker.render_html(file_data,:DEFAULT)
        new_exported_file = "#{Dir.home}/my_exported_notes/#{title}.html"
        File.write(new_exported_file, file_data)
        bar = TTY::ProgressBar.new('exportando [:bar]', total: 10)
        10.times do
          sleep(0.1)
          bar.advance(1)
        end
        puts 'Listo!', :green
      else
        puts "No existe la nota con nombre: '#{title}' en '#{book}'", :red
      end
    else
      puts "No existe cuaderno con nombre: '#{book}'", :red
    end
  end

  def check_export_dir
    if Dir.exist?("#{Dir.home}/my_exported_notes") == false
      puts '--------------------------------------------------'
      puts 'No se detectó carpeta destino de exportación', :yellow
      sleep(1)
      puts 'Creando el directorio en la ubicación por defecto'
      puts "#{Dir.home}/my_exported_notes", :green
      sleep(1)
      puts '--------------------------------------------------'
      puts ' '
      Dir.mkdir("#{Dir.home}/my_exported_notes")
    end
  end
end
