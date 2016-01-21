FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� FileLib -- common file system and path string operations

Caution:

- Coercing file identifier objects to �class bmrk� currently causes AS to crash.

Notes:

- Path manipulation commands all operate on POSIX paths, as those are reliable whereas HFS paths (which are already deprecated everywhere else in OS X) are not. As POSIX paths are the default, handler names do not include the word 'POSIX' as standard; other formats (HFS/Windows/file URL) must be explicitly indicated.

- Library handlers should use LibrarySupportLib's asPOSIXPathParameter(...) to validate user-supplied alias/furl/path parameters and normalize them as POSIX path strings (if a file object is specifically required, just coerce the path string to `POSIX file`). This should insulate library handlers from the worst of the mess that is AS's file identifier types.


TO DO:

- is there a Cocoa API to fuzzily convert IANA charset names to NSString encodings? if so, would be better than hardcoded list of encoding constants

- add `alias object` (`new alias`, `file alias`, `create alias`, `alias for path`, etc?) convenience command (i.e. lightweight equivalent to `convert path PATH to alias file object`) for converting POSIX path to alias object? (analogous to `alias TEXT` specifier, except that it takes POSIX, not HFS, path); see also DateLib, which has similar debate over whether to provide `datetime` convenience command as concise version of `convert record to date` as a more robust alternative to `date TEXT` specifier 

- how does -[NSString stringWithContentsOfFile:encoding:error:] deal with BOM vs encoding param? If it always ignores BOM then, when user specifies any UTF* encoding, would it make sense to sniff file for BOM first and, if found, use that as encoding? (or add `any Unicode encoding` enum which explicitly requires BOM?)

- add `with/without byte order mark` option to `write file`? (Q. what does NSString's writeToFile... method normally do?) if NSString never includes BOM itself, BOM sequence will presumably have to be prefixed to text before converting it to NSString

- add `check path` command that can check if a path (or file identifier object) is an absolute path, `found on disk`, identifies a file/folder/disk/symlink/etc.

- implement Windows path support in `convert path` (suspect this requires CoreFoundation calls, which is a pain)

- what is status of alias and bookmark objects in AS? (the former is deprecated everywhere else in OS X; the latter is poorly supported and rarely appears)

- what about including FileManager commands? (`move disk item`, `duplicate disk item`, `delete disk item` (move to trash/delete file only/recursively delete folders), `get disk item info`, `list disk item contents [with/without invisible items]`, etc) (this would overlap existing functionality in System Events, but TBH System Events' File Suite is glitchy and crap, and itself just duplicates functionality that is (or should be) already in Finder, so there's a good argument for deprecating System Events' File Suite in favor of library-based alternative; OTOH, am reluctant to implement full suite of file management handlers here unless that's likely to happen, otherwise that's just even more complexity for users to wade through; also, to be fair, SE's File Suite has advantage of AEOM support, allowing more sophisticated queries to be performed compared to library handlers


- what about ARGV parsing? would be extremely useful in AS-based shell scripts (ideally along with some way to read STDIN too)

     � 	 	�   F i l e L i b   - -   c o m m o n   f i l e   s y s t e m   a n d   p a t h   s t r i n g   o p e r a t i o n s 
 
 C a u t i o n : 
 
 -   C o e r c i n g   f i l e   i d e n t i f i e r   o b j e c t s   t o   � c l a s s   b m r k �   c u r r e n t l y   c a u s e s   A S   t o   c r a s h . 
 
 N o t e s : 
 
 -   P a t h   m a n i p u l a t i o n   c o m m a n d s   a l l   o p e r a t e   o n   P O S I X   p a t h s ,   a s   t h o s e   a r e   r e l i a b l e   w h e r e a s   H F S   p a t h s   ( w h i c h   a r e   a l r e a d y   d e p r e c a t e d   e v e r y w h e r e   e l s e   i n   O S   X )   a r e   n o t .   A s   P O S I X   p a t h s   a r e   t h e   d e f a u l t ,   h a n d l e r   n a m e s   d o   n o t   i n c l u d e   t h e   w o r d   ' P O S I X '   a s   s t a n d a r d ;   o t h e r   f o r m a t s   ( H F S / W i n d o w s / f i l e   U R L )   m u s t   b e   e x p l i c i t l y   i n d i c a t e d . 
 
 -   L i b r a r y   h a n d l e r s   s h o u l d   u s e   L i b r a r y S u p p o r t L i b ' s   a s P O S I X P a t h P a r a m e t e r ( . . . )   t o   v a l i d a t e   u s e r - s u p p l i e d   a l i a s / f u r l / p a t h   p a r a m e t e r s   a n d   n o r m a l i z e   t h e m   a s   P O S I X   p a t h   s t r i n g s   ( i f   a   f i l e   o b j e c t   i s   s p e c i f i c a l l y   r e q u i r e d ,   j u s t   c o e r c e   t h e   p a t h   s t r i n g   t o   ` P O S I X   f i l e ` ) .   T h i s   s h o u l d   i n s u l a t e   l i b r a r y   h a n d l e r s   f r o m   t h e   w o r s t   o f   t h e   m e s s   t h a t   i s   A S ' s   f i l e   i d e n t i f i e r   t y p e s . 
 
 
 T O   D O : 
 
 -   i s   t h e r e   a   C o c o a   A P I   t o   f u z z i l y   c o n v e r t   I A N A   c h a r s e t   n a m e s   t o   N S S t r i n g   e n c o d i n g s ?   i f   s o ,   w o u l d   b e   b e t t e r   t h a n   h a r d c o d e d   l i s t   o f   e n c o d i n g   c o n s t a n t s 
 
 -   a d d   ` a l i a s   o b j e c t `   ( ` n e w   a l i a s ` ,   ` f i l e   a l i a s ` ,   ` c r e a t e   a l i a s ` ,   ` a l i a s   f o r   p a t h ` ,   e t c ? )   c o n v e n i e n c e   c o m m a n d   ( i . e .   l i g h t w e i g h t   e q u i v a l e n t   t o   ` c o n v e r t   p a t h   P A T H   t o   a l i a s   f i l e   o b j e c t ` )   f o r   c o n v e r t i n g   P O S I X   p a t h   t o   a l i a s   o b j e c t ?   ( a n a l o g o u s   t o   ` a l i a s   T E X T `   s p e c i f i e r ,   e x c e p t   t h a t   i t   t a k e s   P O S I X ,   n o t   H F S ,   p a t h ) ;   s e e   a l s o   D a t e L i b ,   w h i c h   h a s   s i m i l a r   d e b a t e   o v e r   w h e t h e r   t o   p r o v i d e   ` d a t e t i m e `   c o n v e n i e n c e   c o m m a n d   a s   c o n c i s e   v e r s i o n   o f   ` c o n v e r t   r e c o r d   t o   d a t e `   a s   a   m o r e   r o b u s t   a l t e r n a t i v e   t o   ` d a t e   T E X T `   s p e c i f i e r   
 
 -   h o w   d o e s   - [ N S S t r i n g   s t r i n g W i t h C o n t e n t s O f F i l e : e n c o d i n g : e r r o r : ]   d e a l   w i t h   B O M   v s   e n c o d i n g   p a r a m ?   I f   i t   a l w a y s   i g n o r e s   B O M   t h e n ,   w h e n   u s e r   s p e c i f i e s   a n y   U T F *   e n c o d i n g ,   w o u l d   i t   m a k e   s e n s e   t o   s n i f f   f i l e   f o r   B O M   f i r s t   a n d ,   i f   f o u n d ,   u s e   t h a t   a s   e n c o d i n g ?   ( o r   a d d   ` a n y   U n i c o d e   e n c o d i n g `   e n u m   w h i c h   e x p l i c i t l y   r e q u i r e s   B O M ? ) 
 
 -   a d d   ` w i t h / w i t h o u t   b y t e   o r d e r   m a r k `   o p t i o n   t o   ` w r i t e   f i l e ` ?   ( Q .   w h a t   d o e s   N S S t r i n g ' s   w r i t e T o F i l e . . .   m e t h o d   n o r m a l l y   d o ? )   i f   N S S t r i n g   n e v e r   i n c l u d e s   B O M   i t s e l f ,   B O M   s e q u e n c e   w i l l   p r e s u m a b l y   h a v e   t o   b e   p r e f i x e d   t o   t e x t   b e f o r e   c o n v e r t i n g   i t   t o   N S S t r i n g 
 
 -   a d d   ` c h e c k   p a t h `   c o m m a n d   t h a t   c a n   c h e c k   i f   a   p a t h   ( o r   f i l e   i d e n t i f i e r   o b j e c t )   i s   a n   a b s o l u t e   p a t h ,   ` f o u n d   o n   d i s k ` ,   i d e n t i f i e s   a   f i l e / f o l d e r / d i s k / s y m l i n k / e t c . 
 
 -   i m p l e m e n t   W i n d o w s   p a t h   s u p p o r t   i n   ` c o n v e r t   p a t h `   ( s u s p e c t   t h i s   r e q u i r e s   C o r e F o u n d a t i o n   c a l l s ,   w h i c h   i s   a   p a i n ) 
 
 -   w h a t   i s   s t a t u s   o f   a l i a s   a n d   b o o k m a r k   o b j e c t s   i n   A S ?   ( t h e   f o r m e r   i s   d e p r e c a t e d   e v e r y w h e r e   e l s e   i n   O S   X ;   t h e   l a t t e r   i s   p o o r l y   s u p p o r t e d   a n d   r a r e l y   a p p e a r s ) 
 
 -   w h a t   a b o u t   i n c l u d i n g   F i l e M a n a g e r   c o m m a n d s ?   ( ` m o v e   d i s k   i t e m ` ,   ` d u p l i c a t e   d i s k   i t e m ` ,   ` d e l e t e   d i s k   i t e m `   ( m o v e   t o   t r a s h / d e l e t e   f i l e   o n l y / r e c u r s i v e l y   d e l e t e   f o l d e r s ) ,   ` g e t   d i s k   i t e m   i n f o ` ,   ` l i s t   d i s k   i t e m   c o n t e n t s   [ w i t h / w i t h o u t   i n v i s i b l e   i t e m s ] ` ,   e t c )   ( t h i s   w o u l d   o v e r l a p   e x i s t i n g   f u n c t i o n a l i t y   i n   S y s t e m   E v e n t s ,   b u t   T B H   S y s t e m   E v e n t s '   F i l e   S u i t e   i s   g l i t c h y   a n d   c r a p ,   a n d   i t s e l f   j u s t   d u p l i c a t e s   f u n c t i o n a l i t y   t h a t   i s   ( o r   s h o u l d   b e )   a l r e a d y   i n   F i n d e r ,   s o   t h e r e ' s   a   g o o d   a r g u m e n t   f o r   d e p r e c a t i n g   S y s t e m   E v e n t s '   F i l e   S u i t e   i n   f a v o r   o f   l i b r a r y - b a s e d   a l t e r n a t i v e ;   O T O H ,   a m   r e l u c t a n t   t o   i m p l e m e n t   f u l l   s u i t e   o f   f i l e   m a n a g e m e n t   h a n d l e r s   h e r e   u n l e s s   t h a t ' s   l i k e l y   t o   h a p p e n ,   o t h e r w i s e   t h a t ' s   j u s t   e v e n   m o r e   c o m p l e x i t y   f o r   u s e r s   t o   w a d e   t h r o u g h ;   a l s o ,   t o   b e   f a i r ,   S E ' s   F i l e   S u i t e   h a s   a d v a n t a g e   o f   A E O M   s u p p o r t ,   a l l o w i n g   m o r e   s o p h i s t i c a t e d   q u e r i e s   t o   b e   p e r f o r m e d   c o m p a r e d   t o   l i b r a r y   h a n d l e r s 
 
 
 -   w h a t   a b o u t   A R G V   p a r s i n g ?   w o u l d   b e   e x t r e m e l y   u s e f u l   i n   A S - b a s e d   s h e l l   s c r i p t s   ( i d e a l l y   a l o n g   w i t h   s o m e   w a y   t o   r e a d   S T D I N   t o o ) 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        x    �� ����    2   ��
�� 
osax��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��      support     �        s u p p o r t   ! " ! l     ��������  ��  ��   "  # $ # l      % & ' % j    �� (�� 0 _supportlib _supportLib ( N     ) ) 4    �� *
�� 
scpt * m     + + � , , " L i b r a r y S u p p o r t L i b & "  used for parameter checking    ' � - - 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g $  . / . l     ��������  ��  ��   /  0 1 0 l     ��������  ��  ��   1  2 3 2 i   ! 4 5 4 I      �� 6���� 
0 _error   6  7 8 7 o      ���� 0 handlername handlerName 8  9 : 9 o      ���� 0 etext eText :  ; < ; o      ���� 0 enumber eNumber <  = > = o      ���� 0 efrom eFrom >  ?�� ? o      ���� 
0 eto eTo��  ��   5 n     @ A @ I    �� B���� &0 throwcommanderror throwCommandError B  C D C m     E E � F F  F i l e L i b D  G H G o    ���� 0 handlername handlerName H  I J I o    ���� 0 etext eText J  K L K o    	���� 0 enumber eNumber L  M N M o   	 
���� 0 efrom eFrom N  O�� O o   
 ���� 
0 eto eTo��  ��   A o     ���� 0 _supportlib _supportLib 3  P Q P l     ��������  ��  ��   Q  R S R l     ��������  ��  ��   S  T U T l     �� V W��   V J D--------------------------------------------------------------------    W � X X � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - U  Y Z Y l     �� [ \��   [  File Read/Write; these are atomic alternatives to StandardAdditions' File Read/Write suite, with better support for text encodings (incremental read/write is almost entirely useless in practice as AS doesn't have the capabilities or smarts to do it right)    \ � ] ]    F i l e   R e a d / W r i t e ;   t h e s e   a r e   a t o m i c   a l t e r n a t i v e s   t o   S t a n d a r d A d d i t i o n s '   F i l e   R e a d / W r i t e   s u i t e ,   w i t h   b e t t e r   s u p p o r t   f o r   t e x t   e n c o d i n g s   ( i n c r e m e n t a l   r e a d / w r i t e   i s   a l m o s t   e n t i r e l y   u s e l e s s   i n   p r a c t i c e   a s   A S   d o e s n ' t   h a v e   t h e   c a p a b i l i t i e s   o r   s m a r t s   t o   d o   i t   r i g h t ) Z  ^ _ ^ l     ��������  ��  ��   _  ` a ` h   " )�� b�� (0 _nsstringencodings _NSStringEncodings b k       c c  d e d l     �� f g��   f � � note: AS can't natively represent integers larger than 2^30, but as long as they're not larger than 2^50 (1e15) then AS's real (Double) representation will reliably coerce back to integer when passed to ASOC    g � h h�   n o t e :   A S   c a n ' t   n a t i v e l y   r e p r e s e n t   i n t e g e r s   l a r g e r   t h a n   2 ^ 3 0 ,   b u t   a s   l o n g   a s   t h e y ' r e   n o t   l a r g e r   t h a n   2 ^ 5 0   ( 1 e 1 5 )   t h e n   A S ' s   r e a l   ( D o u b l e )   r e p r e s e n t a t i o n   w i l l   r e l i a b l y   c o e r c e   b a c k   t o   i n t e g e r   w h e n   p a s s e d   t o   A S O C e  i j i j     ��� k�� 
0 _list_   k J     � l l  m n m l 	    o���� o J      p p  q r q m     ��
�� FEncFE01 r  s�� s m    ���� ��  ��  ��   n  t u t l 	   v���� v J     w w  x y x m    ��
�� FEncFE02 y  z�� z m    ���� 
��  ��  ��   u  { | { l 	   }���� } J     ~ ~   �  m    	��
�� FEncFE03 �  ��� � m   	 
 � � A�      ��  ��  ��   |  � � � l 	   ����� � J     � �  � � � m    ��
�� FEncFE04 �  ��� � m     � � A�     ��  ��  ��   �  � � � l 	   ����� � J     � �  � � � m    ��
�� FEncFE05 �  ��� � m     � � A�     ��  ��  ��   �  � � � l 	   ����� � J     � �  � � � m    ��
�� FEncFE06 �  ��� � m     � � A�      ��  ��  ��   �  � � � l 	   ����� � J     � �  � � � m    ��
�� FEncFE07 �  ��� � m     � � A�     ��  ��  ��   �  � � � l 	    ����� � J      � �  � � � m    ��
�� FEncFE11 �  ��� � m    ���� ��  ��  ��   �  � � � l 	   & ����� � J     & � �  � � � m     !��
�� FEncFE12 �  ��� � m   ! $���� ��  ��  ��   �  � � � l 	 & . ����� � J   & . � �  � � � m   & )��
�� FEncFE13 �  ��� � m   ) ,���� ��  ��  ��   �  � � � l 	 . 6 ����� � J   . 6 � �  � � � m   . 1��
�� FEncFE14 �  ��� � m   1 4���� 	��  ��  ��   �  � � � l 	 6 < ����� � J   6 < � �  � � � m   6 9��
�� FEncFE15 �  ��� � m   9 :���� ��  ��  ��   �  � � � l 	 < D ����� � J   < D � �  � � � m   < ?��
�� FEncFE16 �  ��� � m   ? B���� ��  ��  ��   �  � � � l 	 D L ����� � J   D L � �  � � � m   D G��
�� FEncFE17 �  ��� � m   G J���� ��  ��  ��   �  � � � l 	 L T ����� � J   L T � �  � � � m   L O��
�� FEncFE18 �  ��� � m   O R���� ��  ��  ��   �  � � � l 	 T \ ���~ � J   T \ � �  � � � m   T W�}
�} FEncFE19 �  ��| � m   W Z�{�{ �|  �  �~   �  � � � l 	 \ d ��z�y � J   \ d � �  � � � m   \ _�x
�x FEncFE50 �  ��w � m   _ b�v�v �w  �z  �y   �  � � � l 	 d l ��u�t � J   d l � �  � � � m   d g�s
�s FEncFE51 �  ��r � m   g j�q�q �r  �u  �t   �  � � � l 	 l t ��p�o � J   l t � �  � � � m   l o�n
�n FEncFE52 �  ��m � m   o r�l�l �m  �p  �o   �  � � � l 	 t | ��k�j � J   t | � �  � � � m   t w�i
�i FEncFE53 �  ��h � m   w z�g�g �h  �k  �j   �  ��f � l 	 | � ��e�d � J   | �    m   | �c
�c FEncFE54 �b m    ��a�a �b  �e  �d  �f   j  l     �`�_�^�`  �_  �^   �] i  � � I      �\	�[�\ 0 getencoding getEncoding	 
�Z
 o      �Y�Y 0 textencoding textEncoding�Z  �[   k     V  Q     K k    3  r     c     o    �X�X 0 textencoding textEncoding m    �W
�W 
enum o      �V�V 0 textencoding textEncoding �U X   	 3�T Z   .�S�R =   ! n     4    �Q!
�Q 
cobj! m    �P�P   o    �O�O 0 aref aRef o     �N�N 0 textencoding textEncoding L   $ *"" n  $ )#$# 4   % (�M%
�M 
cobj% m   & '�L�L $ o   $ %�K�K 0 aref aRef�S  �R  �T 0 aref aRef n   &'& o    �J�J 
0 _list_  '  f    �U   R      �I�H(
�I .ascrerr ****      � ****�H  ( �G)�F
�G 
errn) d      ** m      �E�E��F   l  ; K+,-+ Q   ; K./0. L   > B11 c   > A232 o   > ?�D�D 0 textencoding textEncoding3 m   ? @�C
�C 
long/ R      �B�A4
�B .ascrerr ****      � ****�A  4 �@5�?
�@ 
errn5 d      66 m      �>�>��?  0 l  J J�=78�=  7   fall through   8 �99    f a l l   t h r o u g h, ] W not a predefined constant, but hedge bets as it might be a raw NSStringEncoding number   - �:: �   n o t   a   p r e d e f i n e d   c o n s t a n t ,   b u t   h e d g e   b e t s   a s   i t   m i g h t   b e   a   r a w   N S S t r i n g E n c o d i n g   n u m b e r ;�<; R   L V�;<=
�; .ascrerr ****      � ****< m   T U>> �?? h I n v a l i d    u s i n g    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .= �:@A
�: 
errn@ m   N O�9�9�YA �8BC
�8 
erobB o   P Q�7�7 0 textencoding textEncodingC �6D�5
�6 
errtD m   R S�4
�4 
enum�5  �<  �]   a EFE l     �3�2�1�3  �2  �1  F GHG l     �0�/�.�0  �/  �.  H IJI l     �-KL�-  K  -----   L �MM 
 - - - - -J NON l     �,�+�*�,  �+  �*  O PQP l     �)RS�)  R C = TO DO: option to determine UTF8 encoding from BOM, if found?   S �TT z   T O   D O :   o p t i o n   t o   d e t e r m i n e   U T F 8   e n c o d i n g   f r o m   B O M ,   i f   f o u n d ?Q UVU l     �(�'�&�(  �'  �&  V WXW i  * -YZY I     �%[\
�% .Fil:Readnull���     file[ o      �$�$ 0 thefile theFile\ �#]^
�# 
Type] |�"�!_� `�"  �!  _ o      �� 0 datatype dataType�   ` l     a��a m      �
� 
ctxt�  �  ^ �b�
� 
Encob |��c�d�  �  c o      �� 0 textencoding textEncoding�  d l     e��e m      �
� FEncFE01�  �  �  Z Q     �fghf k    �ii jkj r    lml n   non I    �p�� ,0 asposixpathparameter asPOSIXPathParameterp qrq o    	�� 0 thefile theFiler s�s m   	 
tt �uu  �  �  o o    �� 0 _supportlib _supportLibm o      �� 0 	posixpath 	posixPathk vwv r    xyx n   z{z I    �|�� "0 astypeparameter asTypeParameter| }~} o    �
�
 0 datatype dataType~ �	 m    �� ���  a s�	  �  { o    �� 0 _supportlib _supportLiby o      �� 0 datatype dataTypew ��� Z    ������ F    *��� =   "��� o     �� 0 datatype dataType� m     !�
� 
ctxt� >  % (��� o   % &�� 0 textencoding textEncoding� m   & '�
� FEncFEPE� l  - ����� k   - ��� ��� r   - 9��� n  - 7��� I   2 7� ����  0 getencoding getEncoding� ���� o   2 3���� 0 textencoding textEncoding��  ��  � o   - 2���� (0 _nsstringencodings _NSStringEncodings� o      ���� 0 textencoding textEncoding� ��� r   : S��� n  : D��� I   = D������� T0 (stringwithcontentsoffile_encoding_error_ (stringWithContentsOfFile_encoding_error_� ��� o   = >���� 0 	posixpath 	posixPath� ��� o   > ?���� 0 textencoding textEncoding� ���� l  ? @������ m   ? @��
�� 
obj ��  ��  ��  ��  � n  : =��� o   ; =���� 0 nsstring NSString� m   : ;��
�� misccura� J      �� ��� o      ���� 0 	theresult 	theResult� ���� o      ���� 0 theerror theError��  � ��� Z  T x������� =  T W��� o   T U���� 0 	theresult 	theResult� m   U V��
�� 
msng� R   Z t����
�� .ascrerr ****      � ****� l  l s������ c   l s��� n  l q��� I   m q�������� ,0 localizeddescription localizedDescription��  ��  � o   l m���� 0 theerror theError� m   q r��
�� 
ctxt��  ��  � ����
�� 
errn� n  \ a��� I   ] a�������� 0 code  ��  ��  � o   \ ]���� 0 theerror theError� ����
�� 
erob� o   d e���� 0 thefile theFile� �����
�� 
errt� o   h i���� 0 datatype dataType��  ��  ��  � ��� l  y y��������  ��  ��  � ��� I  y ������
�� .ascrcmnt****      � ****� l  y ~������ n  y ~��� I   z ~�������� 0 description  ��  ��  � o   y z���� 0 	theresult 	theResult��  ��  ��  � ��� l  � ���������  ��  ��  � ���� L   � ��� c   � ���� o   � ����� 0 	theresult 	theResult� m   � ���
�� 
ctxt��  �'! note: AS treats `text`, `string`, and `Unicode text` as synonyms when comparing for equality, which is a little bit problematic as StdAdds' `read` command treats `string` as 'primary encoding' and `Unicode text` as UTF16; passing `primary encoding` for `using` parameter provides an 'out'   � ���B   n o t e :   A S   t r e a t s   ` t e x t ` ,   ` s t r i n g ` ,   a n d   ` U n i c o d e   t e x t `   a s   s y n o n y m s   w h e n   c o m p a r i n g   f o r   e q u a l i t y ,   w h i c h   i s   a   l i t t l e   b i t   p r o b l e m a t i c   a s   S t d A d d s '   ` r e a d `   c o m m a n d   t r e a t s   ` s t r i n g `   a s   ' p r i m a r y   e n c o d i n g '   a n d   ` U n i c o d e   t e x t `   a s   U T F 1 6 ;   p a s s i n g   ` p r i m a r y   e n c o d i n g `   f o r   ` u s i n g `   p a r a m e t e r   p r o v i d e s   a n   ' o u t '�  � k   � ��� ��� r   � ���� I  � ������
�� .rdwropenshor       file� l  � ������� c   � ���� o   � ����� 0 	posixpath 	posixPath� m   � ���
�� 
psxf��  ��  ��  � o      ���� 0 fh  � ���� Q   � ����� k   � ��� ��� l  � ����� r   � ���� I  � �����
�� .rdwrread****        ****� o   � ����� 0 fh  � �����
�� 
as  � o   � ����� 0 datatype dataType��  � o      ���� 0 	theresult 	theResult� r l TO DO: how to produce better error messages (e.g. passing wrong dataType just gives 'Parameter error.' -50)   � ��� �   T O   D O :   h o w   t o   p r o d u c e   b e t t e r   e r r o r   m e s s a g e s   ( e . g .   p a s s i n g   w r o n g   d a t a T y p e   j u s t   g i v e s   ' P a r a m e t e r   e r r o r . '   - 5 0 )� ��� I  � ������
�� .rdwrclosnull���     ****� o   � ����� 0 fh  ��  � ���� L   � ��� o   � ����� 0 	theresult 	theResult��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � k   � ��� ��� Q   � ������ I  � ������
�� .rdwrclosnull���     ****� o   � ����� 0 fh  ��  � R      ������
�� .ascrerr ****      � ****��  ��  ��  � ���� R   � �����
�� .ascrerr ****      � ****� o   � ����� 0 etext eText� ����
�� 
errn� o   � ����� 0 enumber eNumber� ����
�� 
erob� o   � ����� 0 efrom eFrom� �� ��
�� 
errt  o   � ����� 
0 eto eTo��  ��  ��  �  g R      ��
�� .ascrerr ****      � **** o      ���� 0 etext eText ��
�� 
errn o      ���� 0 enumber eNumber ��
�� 
erob o      ���� 0 efrom eFrom ����
�� 
errt o      ���� 
0 eto eTo��  h I   � ������� 
0 _error   	
	 m   � � �  r e a d   f i l e
  o   � ����� 0 etext eText  o   � ����� 0 enumber eNumber  o   � ����� 0 efrom eFrom �� o   � ����� 
0 eto eTo��  ��  X  l     ��������  ��  ��    l     ��������  ��  ��    i  . 1 I     ��
�� .Fil:Writnull���     file o      ���� 0 thefile theFile ��
�� 
Data o      ���� 0 thedata theData � !
� 
Type  |�~�}"�|#�~  �}  " o      �{�{ 0 datatype dataType�|  # l     $�z�y$ m      �x
�x 
ctxt�z  �y  ! �w%�v
�w 
Enco% |�u�t&�s'�u  �t  & o      �r�r 0 textencoding textEncoding�s  ' l     (�q�p( m      �o
�o FEncFE01�q  �p  �v   Q    	)*+) k    �,, -.- r    /0/ n   121 I    �n3�m�n ,0 asposixpathparameter asPOSIXPathParameter3 454 o    	�l�l 0 thefile theFile5 6�k6 m   	 
77 �88  �k  �m  2 o    �j�j 0 _supportlib _supportLib0 o      �i�i 0 	posixpath 	posixPath. 9:9 r    ;<; n   =>= I    �h?�g�h "0 astypeparameter asTypeParameter? @A@ o    �f�f 0 datatype dataTypeA B�eB m    CC �DD  a s�e  �g  > o    �d�d 0 _supportlib _supportLib< o      �c�c 0 datatype dataType: E�bE Z    �FG�aHF F    *IJI =   "KLK o     �`�` 0 datatype dataTypeL m     !�_
�_ 
ctxtJ >  % (MNM o   % &�^�^ 0 textencoding textEncodingN m   & '�]
�] FEncFEPEG k   - �OO PQP r   - ARSR n  - ?TUT I   0 ?�\V�[�\ &0 stringwithstring_ stringWithString_V W�ZW l  0 ;X�Y�XX n  0 ;YZY I   5 ;�W[�V�W "0 astextparameter asTextParameter[ \]\ o   5 6�U�U 0 thedata theData] ^�T^ m   6 7__ �``  d a t a�T  �V  Z o   0 5�S�S 0 _supportlib _supportLib�Y  �X  �Z  �[  U n  - 0aba o   . 0�R�R 0 nsstring NSStringb m   - .�Q
�Q misccuraS o      �P�P 0 
asocstring 
asocStringQ cdc r   B Nefe n  B Lghg I   G L�Oi�N�O 0 getencoding getEncodingi j�Mj o   G H�L�L 0 textencoding textEncoding�M  �N  h o   B G�K�K (0 _nsstringencodings _NSStringEncodingsf o      �J�J 0 textencoding textEncodingd klk r   O kmnm n  O Xopo I   P X�Iq�H�I P0 &writetofile_atomically_encoding_error_ &writeToFile_atomically_encoding_error_q rsr o   P Q�G�G 0 	posixpath 	posixPaths tut m   Q R�F
�F boovtrueu vwv o   R S�E�E 0 textencoding textEncodingw x�Dx l  S Ty�C�By m   S T�A
�A 
obj �C  �B  �D  �H  p o   O P�@�@ 0 
asocstring 
asocStringn J      zz {|{ o      �?�? 0 
didsucceed 
didSucceed| }�>} o      �=�= 0 theerror theError�>  l ~�<~ Z   l ���;�: H   l n�� o   l m�9�9 0 
didsucceed 
didSucceed� R   q ��8��
�8 .ascrerr ****      � ****� l  � ���7�6� c   � ���� n  � ���� I   � ��5�4�3�5 ,0 localizeddescription localizedDescription�4  �3  � o   � ��2�2 0 theerror theError� m   � ��1
�1 
ctxt�7  �6  � �0��
�0 
errn� n  u z��� I   v z�/�.�-�/ 0 code  �.  �-  � o   u v�,�, 0 theerror theError� �+��
�+ 
erob� o   } ~�*�* 0 thefile theFile� �)��(
�) 
errt� o   � ��'�' 0 datatype dataType�(  �;  �:  �<  �a  H k   � ��� ��� r   � ���� I  � ��&��
�& .rdwropenshor       file� l  � ���%�$� c   � ���� o   � ��#�# 0 	posixpath 	posixPath� m   � ��"
�" 
psxf�%  �$  � �!�� 
�! 
perm� m   � ��
� boovtrue�   � o      �� 0 fh  � ��� Q   � ����� k   � ��� ��� l  � ����� I  � ����
� .rdwrseofnull���     ****� o   � ��� 0 fh  � ���
� 
set2� m   � ���  �  � e _ important: when overwriting an existing file, make sure its previous contents are erased first   � ��� �   i m p o r t a n t :   w h e n   o v e r w r i t i n g   a n   e x i s t i n g   f i l e ,   m a k e   s u r e   i t s   p r e v i o u s   c o n t e n t s   a r e   e r a s e d   f i r s t� ��� l  � ����� I  � ����
� .rdwrwritnull���     ****� o   � ��� 0 thedata theData� ���
� 
refn� o   � ��� 0 fh  � ���
� 
as  � o   � ��� 0 datatype dataType�  � 2 , TO DO: how to produce better error messages   � ��� X   T O   D O :   h o w   t o   p r o d u c e   b e t t e r   e r r o r   m e s s a g e s� ��� I  � ����
� .rdwrclosnull���     ****� o   � ��� 0 fh  �  � ��� L   � ��� o   � ��� 0 	theresult 	theResult�  � R      ���
� .ascrerr ****      � ****� o      �
�
 0 etext eText� �	��
�	 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      �� 0 efrom eFrom� ���
� 
errt� o      �� 
0 eto eTo�  � k   � ��� ��� Q   � ����� I  � ���� 
� .rdwrclosnull���     ****� o   � ����� 0 fh  �   � R      ������
�� .ascrerr ****      � ****��  ��  �  � ���� R   � �����
�� .ascrerr ****      � ****� o   � ����� 0 etext eText� ����
�� 
errn� o   � ����� 0 enumber eNumber� ����
�� 
erob� o   � ����� 0 efrom eFrom� �����
�� 
errt� o   � ����� 
0 eto eTo��  ��  �  �b  * R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  + I   �	������� 
0 _error  � ��� m   � ��� ���  w r i t e   f i l e� ��� o   � ���� 0 etext eText� ��� o   ���� 0 enumber eNumber� ��� o  ���� 0 efrom eFrom� ���� o  ���� 
0 eto eTo��  ��   ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  �   POSIX path manipulation   � ��� 0   P O S I X   p a t h   m a n i p u l a t i o n� ��� l     ��������  ��  ��  � ��� i  2 5��� I     ����
�� .Fil:ConPnull���     ****� o      ���� 0 filepath filePath� ����
�� 
From� |����������  ��  � o      ���� 0 
fromformat 
fromFormat��  � l     ������ m      ��
�� FLCTFLCP��  ��  � �����
�� 
To__� |����������  ��  � o      ���� 0 toformat toFormat��  � l     ������ m      ��
�� FLCTFLCP��  ��  ��  � l   �   Q    � k     Z    �	
��	 =     l   ���� I   ��
�� .corecnte****       **** J     �� o    ���� 0 filepath filePath��   ����
�� 
kocl m    ��
�� 
ctxt��  ��  ��   m    ����  
 l    r     n    I    ������ ,0 asposixpathparameter asPOSIXPathParameter  o    ���� 0 filepath filePath �� m     �    ��  ��   o    ���� 0 _supportlib _supportLib o      ���� 0 	posixpath 	posixPath F @ assume it's a file identifier object (alias, �class furl�, etc)    �!! �   a s s u m e   i t ' s   a   f i l e   i d e n t i f i e r   o b j e c t   ( a l i a s ,   � c l a s s   f u r l � ,   e t c )��   l  ! �"#$" Z   ! �%&'(% =  ! $)*) o   ! "���� 0 
fromformat 
fromFormat* m   " #��
�� FLCTFLCP& r   ' *+,+ o   ' (���� 0 filepath filePath, o      ���� 0 	posixpath 	posixPath' -.- =  - 0/0/ o   - .���� 0 
fromformat 
fromFormat0 m   . /��
�� FLCTFLCH. 121 l  3 ;3453 r   3 ;676 n   3 9898 1   7 9��
�� 
psxp9 l  3 7:����: 4   3 7��;
�� 
file; o   5 6���� 0 filepath filePath��  ��  7 o      ���� 0 	posixpath 	posixPath4 � � caution: HFS path format is flawed and deprecated everywhere else in OS X (unlike POSIX path format, it can't distinguish between two volumes with the same name), but is still used by AS and a few older scriptable apps so must be supported   5 �<<�   c a u t i o n :   H F S   p a t h   f o r m a t   i s   f l a w e d   a n d   d e p r e c a t e d   e v e r y w h e r e   e l s e   i n   O S   X   ( u n l i k e   P O S I X   p a t h   f o r m a t ,   i t   c a n ' t   d i s t i n g u i s h   b e t w e e n   t w o   v o l u m e s   w i t h   t h e   s a m e   n a m e ) ,   b u t   i s   s t i l l   u s e d   b y   A S   a n d   a   f e w   o l d e r   s c r i p t a b l e   a p p s   s o   m u s t   b e   s u p p o r t e d2 =>= =  > A?@? o   > ?���� 0 
fromformat 
fromFormat@ m   ? @��
�� FLCTFLCW> ABA l  D HCDEC R   D H��F��
�� .ascrerr ****      � ****F m   F GGG �HH ^ T O D O :   W i n d o w s   p a t h   c o n v e r s i o n   n o t   y e t   s u p p o r t e d��  D W Q CFURLCreateWithFileSystemPath(NULL,(CFStringRef)path,kCFURLWindowsPathStyle,0);    E �II �   C F U R L C r e a t e W i t h F i l e S y s t e m P a t h ( N U L L , ( C F S t r i n g R e f ) p a t h , k C F U R L W i n d o w s P a t h S t y l e , 0 ) ;  B JKJ =  K NLML o   K L���� 0 
fromformat 
fromFormatM m   L M��
�� FLCTFLCUK N��N k   Q �OO PQP r   Q [RSR n  Q YTUT I   T Y��V����  0 urlwithstring_ URLWithString_V W��W o   T U���� 0 filepath filePath��  ��  U n  Q TXYX o   R T���� 0 nsurl NSURLY m   Q R��
�� misccuraS o      ���� 0 asocurl asocURLQ Z��Z Z  \ �[\����[ G   \ l]^] =  \ __`_ o   \ ]���� 0 asocurl asocURL` m   ] ^��
�� 
msng^ H   b haa n  b gbcb I   c g�������� 0 fileurl fileURL��  ��  c o   b c���� 0 asocurl asocURL\ R   o ���de
�� .ascrerr ****      � ****d m   } �ff �gg T I n v a l i d   d i r e c t   p a r a m e t e r   ( n o t   a   f i l e   U R L ) .e ��hi
�� 
errnh m   s v�����Yi ��j��
�� 
erobj o   y z���� 0 filepath filePath��  ��  ��  ��  ��  ( R   � ���kl
�� .ascrerr ****      � ****k m   � �mm �nn f I n v a l i d    f r o m    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .l ��op
�� 
errno m   � ������Yp ��qr
�� 
erobq o   � ����� 0 
fromformat 
fromFormatr ��s��
�� 
errts m   � ���
�� 
enum��  # \ V it's a text path in the user-specified format, so convert it to a standard POSIX path   $ �tt �   i t ' s   a   t e x t   p a t h   i n   t h e   u s e r - s p e c i f i e d   f o r m a t ,   s o   c o n v e r t   i t   t o   a   s t a n d a r d   P O S I X   p a t h uvu l  � ���wx��  w   sanity check   x �yy    s a n i t y   c h e c kv z{z l  � �|}~| Z  � ������ =   � ���� n  � ���� 1   � ��
� 
leng� o   � ��~�~ 0 	posixpath 	posixPath� m   � ��}�}  � R   � ��|��
�| .ascrerr ****      � ****� m   � ��� ��� L I n v a l i d   d i r e c t   p a r a m e t e r   ( e m p t y   p a t h ) .� �{��
�{ 
errn� m   � ��z�z�Y� �y��x
�y 
erob� o   � ��w�w 0 filepath filePath�x  ��  ��  } B < TO DO: what, if any, additional validation to perform here?   ~ ��� x   T O   D O :   w h a t ,   i f   a n y ,   a d d i t i o n a l   v a l i d a t i o n   t o   p e r f o r m   h e r e ?{ ��� l  � ��v���v  � ; 5 convert POSIX path text to the requested format/type   � ��� j   c o n v e r t   P O S I X   p a t h   t e x t   t o   t h e   r e q u e s t e d   f o r m a t / t y p e� ��u� Z   ������ =  � ���� o   � ��t�t 0 toformat toFormat� m   � ��s
�s FLCTFLCP� L   � ��� o   � ��r�r 0 	posixpath 	posixPath� ��� =  � ���� o   � ��q�q 0 toformat toFormat� m   � ��p
�p FLCTFLCA� ��� l  � ����� L   � ��� c   � ���� c   � ���� o   � ��o�o 0 	posixpath 	posixPath� m   � ��n
�n 
psxf� m   � ��m
�m 
alis� %  returns object of type `alias`   � ��� >   r e t u r n s   o b j e c t   o f   t y p e   ` a l i a s `� ��� =  � ���� o   � ��l�l 0 toformat toFormat� m   � ��k
�k FLCTFLCX� ��� l  � ����� L   � ��� c   � ���� o   � ��j�j 0 	posixpath 	posixPath� m   � ��i
�i 
psxf� , & returns object of type `�class furl�`   � ��� L   r e t u r n s   o b j e c t   o f   t y p e   ` � c l a s s   f u r l � `� ��� =  � ���� o   � ��h�h 0 toformat toFormat� m   � ��g
�g FLCTFLCS� ��� l  �	���� L   �	�� N   ��� n   ���� 4   ��f�
�f 
file� l  ���e�d� c   ���� c   ���� o   � �c�c 0 	posixpath 	posixPath� m   �b
�b 
psxf� m  �a
�a 
ctxt�e  �d  � 1   � ��`
�` 
ascr�NH returns an _object specifier_ of type 'file'. Caution: unlike alias and �class furl� objects, this is not a true object but may be used by some applications; not to be confused with the deprecated `file specifier` type (�class fss�), although it uses the same `file TEXT` constructor. Furthermore, it uses an HFS path string so suffers the same problems as HFS paths. Also, being a specifier, requires disambiguation when used [e.g.] in an `open` command otherwise command will be dispatched to it instead of target app, e.g. `tell app "TextEdit" to open {fileSpecifierObject}`. Horribly nasty, brittle, and confusing mis-feature, in other words, but supported (though not encouraged) as an option here for sake of compatibility as there's usually some scriptable app or other API in AS that will absolutely refuse to accept anything else.   � ����   r e t u r n s   a n   _ o b j e c t   s p e c i f i e r _   o f   t y p e   ' f i l e ' .   C a u t i o n :   u n l i k e   a l i a s   a n d   � c l a s s   f u r l �   o b j e c t s ,   t h i s   i s   n o t   a   t r u e   o b j e c t   b u t   m a y   b e   u s e d   b y   s o m e   a p p l i c a t i o n s ;   n o t   t o   b e   c o n f u s e d   w i t h   t h e   d e p r e c a t e d   ` f i l e   s p e c i f i e r `   t y p e   ( � c l a s s   f s s � ) ,   a l t h o u g h   i t   u s e s   t h e   s a m e   ` f i l e   T E X T `   c o n s t r u c t o r .   F u r t h e r m o r e ,   i t   u s e s   a n   H F S   p a t h   s t r i n g   s o   s u f f e r s   t h e   s a m e   p r o b l e m s   a s   H F S   p a t h s .   A l s o ,   b e i n g   a   s p e c i f i e r ,   r e q u i r e s   d i s a m b i g u a t i o n   w h e n   u s e d   [ e . g . ]   i n   a n   ` o p e n `   c o m m a n d   o t h e r w i s e   c o m m a n d   w i l l   b e   d i s p a t c h e d   t o   i t   i n s t e a d   o f   t a r g e t   a p p ,   e . g .   ` t e l l   a p p   " T e x t E d i t "   t o   o p e n   { f i l e S p e c i f i e r O b j e c t } ` .   H o r r i b l y   n a s t y ,   b r i t t l e ,   a n d   c o n f u s i n g   m i s - f e a t u r e ,   i n   o t h e r   w o r d s ,   b u t   s u p p o r t e d   ( t h o u g h   n o t   e n c o u r a g e d )   a s   a n   o p t i o n   h e r e   f o r   s a k e   o f   c o m p a t i b i l i t y   a s   t h e r e ' s   u s u a l l y   s o m e   s c r i p t a b l e   a p p   o r   o t h e r   A P I   i n   A S   t h a t   w i l l   a b s o l u t e l y   r e f u s e   t o   a c c e p t   a n y t h i n g   e l s e .� ��� = ��� o  �_�_ 0 toformat toFormat� m  �^
�^ FLCTFLCH� ��� L  �� c  ��� c  ��� o  �]�] 0 	posixpath 	posixPath� m  �\
�\ 
psxf� m  �[
�[ 
ctxt� ��� =  ��� o  �Z�Z 0 toformat toFormat� m  �Y
�Y FLCTFLCW� ��� l #)���� R  #)�X��W
�X .ascrerr ****      � ****� m  %(�� ��� ^ T O D O :   W i n d o w s   p a t h   c o n v e r s i o n   n o t   y e t   s u p p o r t e d�W  � F @ CFURLCopyFileSystemPath((CFURLRef)url, kCFURLWindowsPathStyle);   � ��� �   C F U R L C o p y F i l e S y s t e m P a t h ( ( C F U R L R e f ) u r l ,   k C F U R L W i n d o w s P a t h S t y l e ) ;� ��� = ,/��� o  ,-�V�V 0 toformat toFormat� m  -.�U
�U FLCTFLCU� ��T� k  2d�� ��� r  2<��� n 2:��� I  5:�S��R�S $0 fileurlwithpath_ fileURLWithPath_� ��Q� o  56�P�P 0 	posixpath 	posixPath�Q  �R  � n 25��� o  35�O�O 0 nsurl NSURL� m  23�N
�N misccura� o      �M�M 0 asocurl asocURL� ��� Z  =[���L�K� = =@��� o  =>�J�J 0 asocurl asocURL� m  >?�I
�I 
msng� R  CW�H��
�H .ascrerr ****      � ****� b  QV��� m  QT�� ��� f C o u l d n ' t   c o n v e r t   t h e   f o l l o w i n g   p a t h   t o   a   f i l e   U R L :  � o  TU�G�G 0 	posixpath 	posixPath� �F��
�F 
errn� m  GJ�E�E�Y� �D �C
�D 
erob  o  MN�B�B 0 filepath filePath�C  �L  �K  � �A L  \d c  \c l \a�@�? n \a I  ]a�>�=�<�>  0 absolutestring absoluteString�=  �<   o  \]�;�; 0 asocurl asocURL�@  �?   m  ab�:
�: 
ctxt�A  �T  � R  g�9	
�9 .ascrerr ****      � **** m  {~

 � b I n v a l i d    t o    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .	 �8
�8 
errn m  kn�7�7�Y �6
�6 
erob o  qr�5�5 0 toformat toFormat �4�3
�4 
errt m  ux�2
�2 
enum�3  �u   R      �1
�1 .ascrerr ****      � **** o      �0�0 0 etext eText �/
�/ 
errn o      �.�. 0 enumber eNumber �-
�- 
erob o      �,�, 0 efrom eFrom �+�*
�+ 
errt o      �)�) 
0 eto eTo�*   I  ���(�'�( 
0 _error    m  �� �  c o n v e r t   p a t h  o  ���&�& 0 etext eText   o  ���%�% 0 enumber eNumber  !"! o  ���$�$ 0 efrom eFrom" #�## o  ���"�" 
0 eto eTo�#  �'   x r brings a modicum of sanity to the horrible mess that is AppleScript's file path formats and file identifier types    �$$ �   b r i n g s   a   m o d i c u m   o f   s a n i t y   t o   t h e   h o r r i b l e   m e s s   t h a t   i s   A p p l e S c r i p t ' s   f i l e   p a t h   f o r m a t s   a n d   f i l e   i d e n t i f i e r   t y p e s� %&% l     �!� ��!  �   �  & '(' l     ����  �  �  ( )*) i  6 9+,+ I     �-.
� .Fil:NorPnull���     ****- o      �� 0 filepath filePath. �/�
� 
ExpR/ |��0�1�  �  0 o      �� 0 isexpanding isExpanding�  1 l     2��2 m      �
� boovfals�  �  �  , Q     R3453 k    @66 787 r    9:9 n   ;<; I    �=�� ,0 asposixpathparameter asPOSIXPathParameter= >?> o    	�� 0 filepath filePath? @�@ m   	 
AA �BB  �  �  < o    �� 0 _supportlib _supportLib: o      �� 0 filepath filePath8 CDC Z    0EF�
�	E F    GHG o    �� 0 isexpanding isExpandingH H    II C    JKJ o    �� 0 filepath filePathK m    LL �MM  /F r    ,NON I   *�P�
� .Fil:JoiPnull���     ****P J    &QQ RSR I   #���
� .Fil:CurFnull��� ��� null�  �  S T�T o   # $� �  0 filepath filePath�  �  O o      ���� 0 filepath filePath�
  �	  D U��U L   1 @VV c   1 ?WXW l  1 =Y����Y n  1 =Z[Z I   9 =�������� 60 stringbystandardizingpath stringByStandardizingPath��  ��  [ l  1 9\����\ n  1 9]^] I   4 9��_���� &0 stringwithstring_ stringWithString__ `��` o   4 5���� 0 filepath filePath��  ��  ^ n  1 4aba o   2 4���� 0 nsstring NSStringb m   1 2��
�� misccura��  ��  ��  ��  X m   = >��
�� 
ctxt��  4 R      ��cd
�� .ascrerr ****      � ****c o      ���� 0 etext eTextd ��ef
�� 
errne o      ���� 0 enumber eNumberf ��g��
�� 
errtg o      ���� 
0 eto eTo��  5 I   H R��h���� 
0 _error  h iji m   I Jkk �ll  n o r m a l i z e   p a t hj mnm o   J K���� 0 etext eTextn opo o   K L���� 0 enumber eNumberp qrq o   L M���� 0 filepath filePathr s��s o   M N���� 
0 eto eTo��  ��  * tut l     ��������  ��  ��  u vwv l     ��������  ��  ��  w xyx i  : =z{z I     ��|}
�� .Fil:JoiPnull���     ****| o      ����  0 pathcomponents pathComponents} ��~��
�� 
Exte~ |���������  ��   o      ���� 0 fileextension fileExtension��  � l     ������ m      ��
�� 
msng��  ��  ��  { Q     ����� k    ��� ��� r    ��� n    ��� 2   ��
�� 
cobj� n   ��� I    ������� "0 aslistparameter asListParameter� ��� o    	����  0 pathcomponents pathComponents� ���� m   	 
�� ���  ��  ��  � o    ���� 0 _supportlib _supportLib� o      ���� 0 subpaths subPaths� ��� Q    \���� k    L�� ��� Z   %������� =   ��� o    ���� 0 subpaths subPaths� J    ����  � R    !������
�� .ascrerr ****      � ****��  ��  ��  ��  � ���� X   & L����� l  6 G���� r   6 G��� n  6 C��� I   ; C������� ,0 asposixpathparameter asPOSIXPathParameter� ��� n  ; >��� 1   < >��
�� 
pcnt� o   ; <���� 0 aref aRef� ���� m   > ?�� ���  ��  ��  � o   6 ;���� 0 _supportlib _supportLib� n     ��� 1   D F��
�� 
pcnt� o   C D���� 0 aref aRef� | v TO DO: how should absolute paths after first item get handled? (e.g. Python's os.path.join discards everything prior)   � ��� �   T O   D O :   h o w   s h o u l d   a b s o l u t e   p a t h s   a f t e r   f i r s t   i t e m   g e t   h a n d l e d ?   ( e . g .   P y t h o n ' s   o s . p a t h . j o i n   d i s c a r d s   e v e r y t h i n g   p r i o r )�� 0 aref aRef� o   ) *���� 0 subpaths subPaths��  � R      ������
�� .ascrerr ****      � ****��  ��  � R   T \����
�� .ascrerr ****      � ****� m   Z [�� ��� � I n v a l i d   p a t h   c o m p o n e n t s   l i s t   ( e x p e c t e d   o n e   o r   m o r e   t e x t   a n d / o r   f i l e   i t e m s ) .� ����
�� 
errn� m   V W�����Y� �����
�� 
erob� o   X Y����  0 pathcomponents pathComponents��  � ��� r   ] i��� l  ] g������ n  ] g��� I   b g������� *0 pathwithcomponents_ pathWithComponents_� ���� o   b c���� 0 subpaths subPaths��  ��  � n  ] b��� o   ^ b���� 0 nsstring NSString� m   ] ^��
�� misccura��  ��  � o      ���� 0 asocpath asocPath� ��� Z   j �������� >  j o��� o   j k���� 0 fileextension fileExtension� m   k n��
�� 
msng� k   r ��� ��� r   r ���� n  r ��� I   w ������� "0 astextparameter asTextParameter� ��� o   w x���� 0 fileextension fileExtension� ���� m   x {�� ��� ( u s i n g   f i l e   e x t e n s i o n��  ��  � o   r w���� 0 _supportlib _supportLib� o      ���� 0 fileextension fileExtension� ��� l  � �������  � _ Y TO DO: trim any leading periods from extension? (NSString doesn't do this automatically)   � ��� �   T O   D O :   t r i m   a n y   l e a d i n g   p e r i o d s   f r o m   e x t e n s i o n ?   ( N S S t r i n g   d o e s n ' t   d o   t h i s   a u t o m a t i c a l l y )� ��� r   � ���� n  � ���� I   � �������� B0 stringbyappendingpathextension_ stringByAppendingPathExtension_� ���� o   � ����� 0 fileextension fileExtension��  ��  � o   � ����� 0 asocpath asocPath� o      ���� 0 asocpath asocPath� ���� Z  � �������� =  � ���� o   � ����� 0 asocpath asocPath� m   � ���
�� 
msng� R   � �����
�� .ascrerr ****      � ****� m   � ��� ��� . I n v a l i d   f i l e   e x t e n s i o n .� ����
�� 
errn� m   � ������Y� �����
�� 
erob� o   � ����� 0 fileextension fileExtension��  ��  ��  ��  ��  ��  � ���� L   � ��� c   � ���� o   � ����� 0 asocpath asocPath� m   � ���
�� 
ctxt��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� ����
�� 
errt� o      �~�~ 
0 eto eTo�  � I   � ��}��|�} 
0 _error  � � � m   � � �  j o i n   p a t h   o   � ��{�{ 0 etext eText  o   � ��z�z 0 enumber eNumber  o   � ��y�y 0 efrom eFrom 	�x	 o   � ��w�w 
0 eto eTo�x  �|  y 

 l     �v�u�t�v  �u  �t    l     �s�r�q�s  �r  �q    i  > A I     �p
�p .Fil:SplPnull���     ctxt o      �o�o 0 filepath filePath �n�m
�n 
Upon |�l�k�j�l  �k   o      �i�i 0 splitposition splitPosition�j   l     �h�g m      �f
�f FLSPFLSL�h  �g  �m   Q     � k    s  r     n    !  I    �e"�d�e &0 stringwithstring_ stringWithString_" #�c# l   $�b�a$ n   %&% I    �`'�_�` ,0 asposixpathparameter asPOSIXPathParameter' ()( o    �^�^ 0 filepath filePath) *�]* m    ++ �,,  �]  �_  & o    �\�\ 0 _supportlib _supportLib�b  �a  �c  �d  ! n   -.- o    �[�[ 0 nsstring NSString. m    �Z
�Z misccura o      �Y�Y 0 asocpath asocPath /�X/ Z    s01230 =   454 o    �W�W 0 splitposition splitPosition5 m    �V
�V FLSPFLSL1 L    /66 J    .77 898 c    %:;: l   #<�U�T< n   #=>= I    #�S�R�Q�S F0 !stringbydeletinglastpathcomponent !stringByDeletingLastPathComponent�R  �Q  > o    �P�P 0 asocpath asocPath�U  �T  ; m   # $�O
�O 
ctxt9 ?�N? c   % ,@A@ l  % *B�M�LB n  % *CDC I   & *�K�J�I�K &0 lastpathcomponent lastPathComponent�J  �I  D o   % &�H�H 0 asocpath asocPath�M  �L  A m   * +�G
�G 
ctxt�N  2 EFE =  2 5GHG o   2 3�F�F 0 splitposition splitPositionH m   3 4�E
�E FLSPFLSEF IJI L   8 IKK J   8 HLL MNM c   8 ?OPO l  8 =Q�D�CQ n  8 =RSR I   9 =�B�A�@�B >0 stringbydeletingpathextension stringByDeletingPathExtension�A  �@  S o   8 9�?�? 0 asocpath asocPath�D  �C  P m   = >�>
�> 
ctxtN T�=T c   ? FUVU l  ? DW�<�;W n  ? DXYX I   @ D�:�9�8�: 0 pathextension pathExtension�9  �8  Y o   ? @�7�7 0 asocpath asocPath�<  �;  V m   D E�6
�6 
ctxt�=  J Z[Z =  L O\]\ o   L M�5�5 0 splitposition splitPosition] m   M N�4
�4 FLSPFLSA[ ^�3^ L   R Z__ c   R Y`a` l  R Wb�2�1b n  R Wcdc I   S W�0�/�.�0  0 pathcomponents pathComponents�/  �.  d o   R S�-�- 0 asocpath asocPath�2  �1  a m   W X�,
�, 
list�3  3 R   ] s�+ef
�+ .ascrerr ****      � ****e m   o rgg �hh b I n v a l i d    a t    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .f �*ij
�* 
errni m   _ b�)�)�Yj �(kl
�( 
erobk o   e f�'�' 0 matchformat matchFormatl �&m�%
�& 
errtm m   i l�$
�$ 
enum�%  �X   R      �#no
�# .ascrerr ****      � ****n o      �"�" 0 etext eTexto �!pq
�! 
errnp o      � �  0 enumber eNumberq �rs
� 
erobr o      �� 0 efrom eFroms �t�
� 
errtt o      �� 
0 eto eTo�   I   { ��u�� 
0 _error  u vwv m   | xx �yy  s p l i t   p a t hw z{z o    ��� 0 etext eText{ |}| o   � ��� 0 enumber eNumber} ~~ o   � ��� 0 efrom eFrom ��� o   � ��� 
0 eto eTo�  �   ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ����  �   Information   � ���    I n f o r m a t i o n� ��� l     ��
�	�  �
  �	  � ��� i  B E��� I     ���
� .Fil:CurFnull��� ��� null�  �  � Q     :���� k    (�� ��� r    ��� n   ��� I   
 ���� ,0 currentdirectorypath currentDirectoryPath�  �  � n   
��� I    
��� �  0 defaultmanager defaultManager�  �   � n   ��� o    ���� 0 nsfilemanager NSFileManager� m    ��
�� misccura� o      ���� 0 thepath thePath� ��� Z   !������� =   ��� o    ���� 0 thepath thePath� m    ��
�� 
msng� R    ����
�� .ascrerr ****      � ****� m    �� ���  N o t   a v a i l a b l e .� �����
�� 
errn� m    �����@��  ��  ��  � ���� L   " (�� c   " '��� c   " %��� o   " #���� 0 thepath thePath� m   # $��
�� 
ctxt� m   % &��
�� 
psxf��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I   0 :������� 
0 _error  � ��� m   1 2�� ���  c u r r e n t   f o l d e r� ��� o   2 3���� 0 etext eText� ��� o   3 4���� 0 enumber eNumber� ��� o   4 5���� 0 efrom eFrom� ���� o   5 6���� 
0 eto eTo��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ���� l     ��������  ��  ��  ��       ����������������  � ����������������������
�� 
pimr�� 0 _supportlib _supportLib�� 
0 _error  �� (0 _nsstringencodings _NSStringEncodings
�� .Fil:Readnull���     file
�� .Fil:Writnull���     file
�� .Fil:ConPnull���     ****
�� .Fil:NorPnull���     ****
�� .Fil:JoiPnull���     ****
�� .Fil:SplPnull���     ctxt
�� .Fil:CurFnull��� ��� null� ����� �  ��� �����
�� 
cobj� ��   �� 
�� 
frmk��  � �����
�� 
cobj� ��   ��
�� 
osax��  � ��   �� +
�� 
scpt� �� 5���������� 
0 _error  �� ����� �  ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo��  � ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo�  E������ �� &0 throwcommanderror throwCommandError�� b  ࠡ����+ � �� b  ��� (0 _nsstringencodings _NSStringEncodings�  ���� ������ 
0 _list_  �� 0 getencoding getEncoding� ����� �  ���������������������� ����� �  ����
�� FEncFE01�� � �� ��    ����
�� FEncFE02�� 
� ����   �� �
�� FEncFE03� ����   �� �
�� FEncFE04� ����   �� �
�� FEncFE05� ����   �� �
�� FEncFE06� ����   �� �
�� FEncFE07� ����   ����
�� FEncFE11�� � ����   ����
�� FEncFE12�� � ����   ����
�� FEncFE13�� � ��	�� 	  ����
�� FEncFE14�� 	� ��
�� 
  ����
�� FEncFE15�� � ����   ����
�� FEncFE16�� � ����   ����
�� FEncFE17�� � ����   ����
�� FEncFE18�� � ����   ����
�� FEncFE19�� � ��   �~�}
�~ FEncFE50�} � �|�|   �{�z
�{ FEncFE51�z � �y�y   �x�w
�x FEncFE52�w � �v�v   �u�t
�u FEncFE53�t � �s�s   �r�q
�r FEncFE54�q � �p�o�n�m�p 0 getencoding getEncoding�o �l�l   �k�k 0 textencoding textEncoding�n   �j�i�j 0 textencoding textEncoding�i 0 aref aRef �h�g�f�e�d�c�b�a�`�_�^�]>
�h 
enum�g 
0 _list_  
�f 
kocl
�e 
cobj
�d .corecnte****       ****�c   �\�[�Z
�\ 
errn�[�\�Z  
�b 
long
�a 
errn�`�Y
�_ 
erob
�^ 
errt�] �m W 5��&E�O ))�,[��l kh ��k/�  ��l/EY h[OY��W X   	��&W X  hO)�������� �YZ�X�W�V
�Y .Fil:Readnull���     file�X 0 thefile theFile�W �U
�U 
Type {�T�S�R�T 0 datatype dataType�S  
�R 
ctxt �Q�P
�Q 
Enco {�O�N�M�O 0 textencoding textEncoding�N  
�M FEncFE01�P   �L�K�J�I�H�G�F�E�D�C�B�L 0 thefile theFile�K 0 datatype dataType�J 0 textencoding textEncoding�I 0 	posixpath 	posixPath�H 0 	theresult 	theResult�G 0 theerror theError�F 0 fh  �E 0 etext eText�D 0 enumber eNumber�C 0 efrom eFrom�B 
0 eto eTo "t�A��@�?�>�=�<�;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�A ,0 asposixpathparameter asPOSIXPathParameter�@ "0 astypeparameter asTypeParameter
�? 
ctxt
�> FEncFEPE
�= 
bool�< 0 getencoding getEncoding
�; misccura�: 0 nsstring NSString
�9 
obj �8 T0 (stringwithcontentsoffile_encoding_error_ (stringWithContentsOfFile_encoding_error_
�7 
cobj
�6 
msng
�5 
errn�4 0 code  
�3 
erob
�2 
errt�1 �0 ,0 localizeddescription localizedDescription�/ 0 description  
�. .ascrcmnt****      � ****
�- 
psxf
�, .rdwropenshor       file
�+ 
as  
�* .rdwrread****        ****
�) .rdwrclosnull���     ****�( 0 etext eText �#�"
�# 
errn�" 0 enumber eNumber �!� 
�! 
erob�  0 efrom eFrom ���
� 
errt� 
0 eto eTo�  �'  �&  �% �$ 
0 _error  �V � �b  ��l+ E�Ob  ��l+ E�O�� 	 ���& _b  �k+ E�O��,���m+ E[�k/E�Z[�l/E�ZO��  )�j+ a �a �a �j+ �&Y hO�j+ j O��&Y O�a &j E�O �a �l E�O�j O�W )X   
�j W X  hO)�a �a �a �W X  *a ����a  + !� ��� !�
� .Fil:Writnull���     file� 0 thefile theFile� ��"
� 
Data� 0 thedata theData" �#$
� 
Type# {���� 0 datatype dataType�  
� 
ctxt$ �%�
� 
Enco% {���� 0 textencoding textEncoding�  
� FEncFE01�    ����
�	��������� � 0 thefile theFile� 0 thedata theData� 0 datatype dataType�
 0 textencoding textEncoding�	 0 	posixpath 	posixPath� 0 
asocstring 
asocString� 0 
didsucceed 
didSucceed� 0 theerror theError� 0 fh  � 0 	theresult 	theResult� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom�  
0 eto eTo! '7��C������������_����������������������������������������������&����������� ,0 asposixpathparameter asPOSIXPathParameter�� "0 astypeparameter asTypeParameter
�� 
ctxt
�� FEncFEPE
�� 
bool
�� misccura�� 0 nsstring NSString�� "0 astextparameter asTextParameter�� &0 stringwithstring_ stringWithString_�� 0 getencoding getEncoding
�� 
obj �� �� P0 &writetofile_atomically_encoding_error_ &writeToFile_atomically_encoding_error_
�� 
cobj
�� 
errn�� 0 code  
�� 
erob
�� 
errt�� �� ,0 localizeddescription localizedDescription
�� 
psxf
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� 
as  
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****�� 0 etext eText& ����'
�� 
errn�� 0 enumber eNumber' ����(
�� 
erob�� 0 efrom eFrom( ������
�� 
errt�� 
0 eto eTo��  ��  ��  �� �� 
0 _error  �
 �b  ��l+ E�Ob  ��l+ E�O�� 	 ���& i��,b  ��l+ 
k+ E�Ob  �k+ E�O��e���+ E[a k/E�Z[a l/E�ZO� !)a �j+ a �a �a �j+ �&Y hY a�a &a el E�O %�a jl O�a �a �� O�j O�W +X   ! 
�j W X " #hO)a �a �a �a �W X   !*a $����a %+ &� �������)*��
�� .Fil:ConPnull���     ****�� 0 filepath filePath�� ��+,
�� 
From+ {�������� 0 
fromformat 
fromFormat��  
�� FLCTFLCP, ��-��
�� 
To__- {�������� 0 toformat toFormat��  
�� FLCTFLCP��  ) 	�������������������� 0 filepath filePath�� 0 
fromformat 
fromFormat�� 0 toformat toFormat�� 0 	posixpath 	posixPath�� 0 asocurl asocURL�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo* -������������������G����������������������f������m���������������������
��.����
�� 
kocl
�� 
ctxt
�� .corecnte****       ****�� ,0 asposixpathparameter asPOSIXPathParameter
�� FLCTFLCP
�� FLCTFLCH
�� 
file
�� 
psxp
�� FLCTFLCW
�� FLCTFLCU
�� misccura�� 0 nsurl NSURL��  0 urlwithstring_ URLWithString_
�� 
msng�� 0 fileurl fileURL
�� 
bool
�� 
errn���Y
�� 
erob�� 
�� 
errt
�� 
enum�� 
�� 
leng
�� FLCTFLCA
�� 
psxf
�� 
alis
�� FLCTFLCX
�� FLCTFLCS
�� 
ascr�� $0 fileurlwithpath_ fileURLWithPath_��  0 absolutestring absoluteString�� 0 etext eText. ����/
�� 
errn�� 0 enumber eNumber/ ����0
�� 
erob�� 0 efrom eFrom0 ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �����kv��l j  b  ��l+ E�Y ���  �E�Y u��  *�/�,E�Y d��  	)j�Y W��  9��,�k+ E�O�� 
 �j+ a & )a a a �a a Y hY )a a a �a a a a O�a ,j  )a a a �a a Y hO��  �Y ��a   �a &a &Y ��a    �a &Y ��a !  _ "�a &�&/Y u��  �a &�&Y d��  )ja #Y U��  7��,�k+ $E�O��  )a a a �a a %�%Y hO�j+ &�&Y )a a a �a a a a 'W X ( )*a *����a ++ ,� ��,����12��
�� .Fil:NorPnull���     ****�� 0 filepath filePath�� ��3��
�� 
ExpR3 {�������� 0 isexpanding isExpanding��  
�� boovfals��  1 ������������ 0 filepath filePath�� 0 isexpanding isExpanding�� 0 etext eText�� 0 enumber eNumber�� 
0 eto eTo2 A��L�����������������4k�~�}�� ,0 asposixpathparameter asPOSIXPathParameter
�� 
bool
�� .Fil:CurFnull��� ��� null
�� .Fil:JoiPnull���     ****
�� misccura�� 0 nsstring NSString�� &0 stringwithstring_ stringWithString_�� 60 stringbystandardizingpath stringByStandardizingPath
�� 
ctxt� 0 etext eText4 �|�{5
�| 
errn�{ 0 enumber eNumber5 �z�y�x
�z 
errt�y 
0 eto eTo�x  �~ �} 
0 _error  �� S Bb  ��l+ E�O�	 ���& *j �lvj E�Y hO��,�k+ j+ 	�&W X  *������+ � �w{�v�u67�t
�w .Fil:JoiPnull���     ****�v  0 pathcomponents pathComponents�u �s8�r
�s 
Exte8 {�q�p�o�q 0 fileextension fileExtension�p  
�o 
msng�r  6 	�n�m�l�k�j�i�h�g�f�n  0 pathcomponents pathComponents�m 0 fileextension fileExtension�l 0 subpaths subPaths�k 0 aref aRef�j 0 asocpath asocPath�i 0 etext eText�h 0 enumber eNumber�g 0 efrom eFrom�f 
0 eto eTo7 ��e�d�c�b�a��`�_�^�]�\�[�Z��Y�X�W�V��U�T��S�R9�Q�P�e "0 aslistparameter asListParameter
�d 
cobj
�c 
kocl
�b .corecnte****       ****
�a 
pcnt�` ,0 asposixpathparameter asPOSIXPathParameter�_  �^  
�] 
errn�\�Y
�[ 
erob�Z 
�Y misccura�X 0 nsstring NSString�W *0 pathwithcomponents_ pathWithComponents_
�V 
msng�U "0 astextparameter asTextParameter�T B0 stringbyappendingpathextension_ stringByAppendingPathExtension_
�S 
ctxt�R 0 etext eText9 �O�N:
�O 
errn�N 0 enumber eNumber: �M�L;
�M 
erob�L 0 efrom eFrom; �K�J�I
�K 
errt�J 
0 eto eTo�I  �Q �P 
0 _error  �t � �b  ��l+ �-E�O ;�jv  	)jhY hO %�[��l kh b  ��,�l+ ��,F[OY��W X  	)�����O�a ,�k+ E�O�a  4b  �a l+ E�O��k+ E�O�a   )����a Y hY hO�a &W X  *a ����a + � �H�G�F<=�E
�H .Fil:SplPnull���     ctxt�G 0 filepath filePath�F �D>�C
�D 
Upon> {�B�A�@�B 0 splitposition splitPosition�A  
�@ FLSPFLSL�C  < �?�>�=�<�;�:�9�8�? 0 filepath filePath�> 0 splitposition splitPosition�= 0 asocpath asocPath�< 0 matchformat matchFormat�; 0 etext eText�: 0 enumber eNumber�9 0 efrom eFrom�8 
0 eto eTo= �7�6+�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$g�#?x�"�!
�7 misccura�6 0 nsstring NSString�5 ,0 asposixpathparameter asPOSIXPathParameter�4 &0 stringwithstring_ stringWithString_
�3 FLSPFLSL�2 F0 !stringbydeletinglastpathcomponent !stringByDeletingLastPathComponent
�1 
ctxt�0 &0 lastpathcomponent lastPathComponent
�/ FLSPFLSE�. >0 stringbydeletingpathextension stringByDeletingPathExtension�- 0 pathextension pathExtension
�, FLSPFLSA�+  0 pathcomponents pathComponents
�* 
list
�) 
errn�(�Y
�' 
erob
�& 
errt
�% 
enum�$ �# 0 etext eText? � �@
�  
errn� 0 enumber eNumber@ ��A
� 
erob� 0 efrom eFromA ���
� 
errt� 
0 eto eTo�  �" �! 
0 _error  �E � u��,b  ��l+ k+ E�O��  �j+ �&�j+ �&lvY C��  �j+ 
�&�j+ �&lvY )��  �j+ �&Y )�a a �a a a a W X  *a ����a + � ����BC�
� .Fil:CurFnull��� ��� null�  �  B ������ 0 thepath thePath� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eToC �������
��	��D���
� misccura� 0 nsfilemanager NSFileManager�  0 defaultmanager defaultManager� ,0 currentdirectorypath currentDirectoryPath
� 
msng
� 
errn�
�@
�	 
ctxt
� 
psxf� 0 etext eTextD ��E
� 
errn� 0 enumber eNumberE ��F
� 
erob� 0 efrom eFromF � ����
�  
errt�� 
0 eto eTo��  � � 
0 _error  � ; *��,j+ j+ E�O��  )��l�Y hO��&�&W X 
 *졢���+  ascr  ��ޭ