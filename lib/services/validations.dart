
class Validations{
  String validateName(String value) {
    if (value.isEmpty) return 'Nombre es un campo requerido.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Porfavor ingrese sólo caracteres alfanuméricos.';
    return null;
  }

  String validateEmail(String value) {
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

  String validateCode(String code) {
    if (code.isEmpty) return "Ingrese el código identificador del tendero";
    try {
      int.parse(code);
      return null;
    } catch (e) {
      return "El código debe ser un número";
    }
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
}