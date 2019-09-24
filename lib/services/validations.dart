
class Validations{
  String validateName(String value) {
    if (value == null || value.isEmpty) return 'Nombre es un campo requerido.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value)) return 'Porfavor ingrese sólo caracteres alfanuméricos.';
    return null;
  }

  String validateEmail(String value) {
    if (value == null) return 'Ingrese un correo';
    if (value.isEmpty) return 'Correo es un campo requerido.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Correo electrónico inválido';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Porfavor, escoja una contraseña.';
    return null;
  }

  String validatePhoneNumber(String val){
    if (val == null) return "Ingrese un número de teléfono";
    if (val.isEmpty) return "Ingrese el número de teléfono";
    final RegExp phoneExp = RegExp(r'^(\(\+?\d{2,3}\)[\*|\s|\-|\.]?(([\d][\*|\s|\-|\.]?){6})(([\d][\s|\-|\.]?){2})?|(\+?[\d][\s|\-|\.]?){8}(([\d][\s|\-|\.]?){2}(([\d][\s|\-|\.]?){2})?)?)$');
    if(!phoneExp.hasMatch(val)) return 'Número de telefóno inválido';
    return null;
  }

  String validateAge(String age){
    if(age.isEmpty) return null;
    try {
      int intAge = int.parse(age);
      if (intAge > 200) return 'La edad es demasiado grande';
      return null;
    } catch (e) {
      return 'La edad debe ser un número';
    }
  }

  String validateFrigdeDoors(String doors) {
    if(doors.isEmpty) return "Ingrese el número de puertas";
    try {
      int intDoors = int.parse(doors);
      if(intDoors > 100) return "El número de puertas es demasiado grande";
      return null;
    } catch (e) {
      return 'Ingrese un número en el campo "Puertas de refrigeradores"';
    }
  }

  String validateCode(String code) {
    if (code.isEmpty) return "Ingrese el código identificador del tendero";
    final RegExp codeExp = RegExp(r"[a-zA-Z\d]{6}");
    if(code.length > 6 || code.length < 6) return "El código debe ser de 6 dígitos";
    if (!codeExp.hasMatch(code)) return "Código incorrecto";
    return null;
  }

  String validateShopAddress(String val) {
    if (val.isEmpty) return "Ingrese la dirección de la tienda";
    return null;
  }

  String validateShopName(String value) {
    if (value.isEmpty) return 'Nombre es un campo requerido.';
    final RegExp nameExp = new RegExp(r'^[A-za-zñÑ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Porfavor ingrese sólo caracteres alfanuméricos.';
    return null;
  }

  String validateUsername(String val) {
    if (val.isEmpty) return 'Ingrese su usuario';
    final RegExp nameExp = new RegExp(r'^[A-za-zñÑ \d]+$');
    if (!nameExp.hasMatch(val))
      return 'Porfavor ingrese sólo caracteres alfanuméricos.';
    return null;
  }

  String validatePostalCode(String val) {
    if (val.isEmpty) return 'Ingrese el código postal de la tienda';
    final RegExp nameExp = new RegExp(r'^\d{4,5}$');
    if (!nameExp.hasMatch(val))
      return 'El código postal está en un formato incorrecto.';
    return null;
  }
}