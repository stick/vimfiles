:silent! %s/\['modulename'\]/\=b:modulename/g
:silent! %s/\['classpath'\]/\=b:classpath/g
:if search('<+CURSOR+>')
: normal! "_da>
:endif
# Class: ['classpath']
#
# == Variables
#
# [*$foo_var*]
#     Description of this variable
#
# == Examples
#
#   $example_var = "blah"
#   include ['classpath']
#
class ['classpath'] {
  <+CURSOR+>
}
