Summary: 
Name: @FILE@
Version: 
Release: 1
License: 
Group: 
URL: 
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc


%changelog
* @DATE@ @NAME@ <@EMAIL@> 
- Initial build.



