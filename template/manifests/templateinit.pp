:silent! %s/\['modulename'\]/\=b:module_name/g
:silent! %s/\['classpath'\]/\=b:classpath/g
:if search('<+CURSOR+>')
: normal! "_da>
:endif
# Class: ['classpath']
#   init base classes should generally not do much but include
#   other classes and set variables
#
# == Variables
#
# [*$foo_var*]
#     Description of this variable
#
# == Examples
#
#   $example_var = "blah"
#   include ['modulename']
#
class ['modulename'] {
  <+CURSOR+>
}
