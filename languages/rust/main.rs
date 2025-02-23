use std::io;

fn main() {
    println!("Пожалуйста, введите свою строку");

    let mut user_input = String::new();

    let result = io::stdin()
        .read_line(&mut user_input)
        .expect("Не удалось прочитать ввод");

    println!("Вы ввели: {user_input}");
    println!("result = {result}");
}

// трейты
