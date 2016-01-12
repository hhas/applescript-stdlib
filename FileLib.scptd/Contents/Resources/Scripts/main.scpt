FasdUAS 1.101.10   ��   ��    k             l      ��  ��   
�
� FileLib -- common file system and path string operations

Caution:

- Coercing file identifier objects to �class bmrk� currently causes AS to crash.

Notes:

- Path manipulation commands all operate on POSIX paths, as those are reliable whereas HFS paths (which are already deprecated everywhere else in OS X) are not. As POSIX paths are the default, handler names do not include the word 'POSIX' as standard; other formats (HFS/Windows/file URL) must be explicitly indicated.

- Library handlers should use LibrarySupportLib's asPOSIXPathParameter(...) to validate user-supplied alias/furl/path parameters and normalize them as POSIX path strings (if a file object is specifically required, just coerce the path string to `POSIX file`). This should insulate library handlers from the worst of the mess that is AS's file identifier types.


TO DO:

- how does -[NSString stringWithContentsOfFile:encoding:error:] deal with BOM vs encoding param? If it always ignores BOM then, when user specifies any UTF* encoding, would it make sense to sniff file for BOM first and, if found, use that as encoding? (or add `any Unicode encoding` enum which explicitly requires BOM?)

- add `with/without byte order mark` option to `write file`? (Q. what does NSString's writeToFile... method normally do?) if NSString never includes BOM itself, BOM sequence will presumably have to be prefixed to text before converting it to NSString

- add `check path` command that can check if a path (or file identifier object) is an absolute path, `found on disk`, identifies a file/folder/disk/symlink/etc.

- support Windows path format in `convert path` (suspect this requires CoreFoundation calls, which is a pain)

- what is status of alias and bookmark objects in AS? (the former is deprecated everywhere else in OS X; the latter is poorly supported and rarely appears)

- what about including FileManager commands? (`move disk item`, `duplicate disk item`, `delete disk item` (move to trash/delete file only/recursively delete folders), `get disk item info`, `list disk item contents [with/without invisible items]`, etc) (this would overlap existing functionality in System Events, but TBH System Events' File Suite is glitchy and crap, and itself just duplicates functionality that is (or should be) already in Finder, so there's a good argument for deprecating System Events' File Suite in favor of library-based alternative; OTOH, am reluctant to implement full suite of file management handlers here unless that's likely to happen, otherwise that's just even more complexity for users to wade through; also, to be fair, SE's File Suite has advantage of AEOM support, allowing more sophisticated queries to be performed compared to library handlers

     � 	 	b   F i l e L i b   - -   c o m m o n   f i l e   s y s t e m   a n d   p a t h   s t r i n g   o p e r a t i o n s 
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
 -   h o w   d o e s   - [ N S S t r i n g   s t r i n g W i t h C o n t e n t s O f F i l e : e n c o d i n g : e r r o r : ]   d e a l   w i t h   B O M   v s   e n c o d i n g   p a r a m ?   I f   i t   a l w a y s   i g n o r e s   B O M   t h e n ,   w h e n   u s e r   s p e c i f i e s   a n y   U T F *   e n c o d i n g ,   w o u l d   i t   m a k e   s e n s e   t o   s n i f f   f i l e   f o r   B O M   f i r s t   a n d ,   i f   f o u n d ,   u s e   t h a t   a s   e n c o d i n g ?   ( o r   a d d   ` a n y   U n i c o d e   e n c o d i n g `   e n u m   w h i c h   e x p l i c i t l y   r e q u i r e s   B O M ? ) 
 
 -   a d d   ` w i t h / w i t h o u t   b y t e   o r d e r   m a r k `   o p t i o n   t o   ` w r i t e   f i l e ` ?   ( Q .   w h a t   d o e s   N S S t r i n g ' s   w r i t e T o F i l e . . .   m e t h o d   n o r m a l l y   d o ? )   i f   N S S t r i n g   n e v e r   i n c l u d e s   B O M   i t s e l f ,   B O M   s e q u e n c e   w i l l   p r e s u m a b l y   h a v e   t o   b e   p r e f i x e d   t o   t e x t   b e f o r e   c o n v e r t i n g   i t   t o   N S S t r i n g 
 
 -   a d d   ` c h e c k   p a t h `   c o m m a n d   t h a t   c a n   c h e c k   i f   a   p a t h   ( o r   f i l e   i d e n t i f i e r   o b j e c t )   i s   a n   a b s o l u t e   p a t h ,   ` f o u n d   o n   d i s k ` ,   i d e n t i f i e s   a   f i l e / f o l d e r / d i s k / s y m l i n k / e t c . 
 
 -   s u p p o r t   W i n d o w s   p a t h   f o r m a t   i n   ` c o n v e r t   p a t h `   ( s u s p e c t   t h i s   r e q u i r e s   C o r e F o u n d a t i o n   c a l l s ,   w h i c h   i s   a   p a i n ) 
 
 -   w h a t   i s   s t a t u s   o f   a l i a s   a n d   b o o k m a r k   o b j e c t s   i n   A S ?   ( t h e   f o r m e r   i s   d e p r e c a t e d   e v e r y w h e r e   e l s e   i n   O S   X ;   t h e   l a t t e r   i s   p o o r l y   s u p p o r t e d   a n d   r a r e l y   a p p e a r s ) 
 
 -   w h a t   a b o u t   i n c l u d i n g   F i l e M a n a g e r   c o m m a n d s ?   ( ` m o v e   d i s k   i t e m ` ,   ` d u p l i c a t e   d i s k   i t e m ` ,   ` d e l e t e   d i s k   i t e m `   ( m o v e   t o   t r a s h / d e l e t e   f i l e   o n l y / r e c u r s i v e l y   d e l e t e   f o l d e r s ) ,   ` g e t   d i s k   i t e m   i n f o ` ,   ` l i s t   d i s k   i t e m   c o n t e n t s   [ w i t h / w i t h o u t   i n v i s i b l e   i t e m s ] ` ,   e t c )   ( t h i s   w o u l d   o v e r l a p   e x i s t i n g   f u n c t i o n a l i t y   i n   S y s t e m   E v e n t s ,   b u t   T B H   S y s t e m   E v e n t s '   F i l e   S u i t e   i s   g l i t c h y   a n d   c r a p ,   a n d   i t s e l f   j u s t   d u p l i c a t e s   f u n c t i o n a l i t y   t h a t   i s   ( o r   s h o u l d   b e )   a l r e a d y   i n   F i n d e r ,   s o   t h e r e ' s   a   g o o d   a r g u m e n t   f o r   d e p r e c a t i n g   S y s t e m   E v e n t s '   F i l e   S u i t e   i n   f a v o r   o f   l i b r a r y - b a s e d   a l t e r n a t i v e ;   O T O H ,   a m   r e l u c t a n t   t o   i m p l e m e n t   f u l l   s u i t e   o f   f i l e   m a n a g e m e n t   h a n d l e r s   h e r e   u n l e s s   t h a t ' s   l i k e l y   t o   h a p p e n ,   o t h e r w i s e   t h a t ' s   j u s t   e v e n   m o r e   c o m p l e x i t y   f o r   u s e r s   t o   w a d e   t h r o u g h ;   a l s o ,   t o   b e   f a i r ,   S E ' s   F i l e   S u i t e   h a s   a d v a n t a g e   o f   A E O M   s u p p o r t ,   a l l o w i n g   m o r e   s o p h i s t i c a t e d   q u e r i e s   t o   b e   p e r f o r m e d   c o m p a r e d   t o   l i b r a r y   h a n d l e r s 
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
� FEncFEPE� l  - f���� k   - f�� ��� r   - 9��� n  - 7��� I   2 7� ����  0 getencoding getEncoding� ���� o   2 3���� 0 textencoding textEncoding��  ��  � o   - 2���� (0 _nsstringencodings _NSStringEncodings� o      ���� 0 textencoding textEncoding� ��� l  : C���� r   : C��� N   : A�� n   : @��� 4   = @���
�� 
cobj� m   > ?���� � J   : =�� ���� m   : ;��
�� 
msng��  � o      ���� 0 errorref errorRef�   TO DO   � ���    T O   D O� ��� r   D P��� n  D N��� I   G N������� T0 (stringwithcontentsoffile_encoding_error_ (stringWithContentsOfFile_encoding_error_� ��� o   G H���� 0 	posixpath 	posixPath� ��� o   H I���� 0 textencoding textEncoding� ���� o   I J���� 0 errorref errorRef��  ��  � n  D G��� o   E G���� 0 nsstring NSString� m   D E��
�� misccura� o      ���� 0 	theresult 	theResult� ��� l  Q a���� Z  Q a������� =  Q T��� o   Q R���� 0 	theresult 	theResult� m   R S��
�� 
msng� R   W ]����
�� .ascrerr ****      � ****� m   [ \�� ��� ( F a i l e d   t o   r e a d   f i l e .� �����
�� 
errn� m   Y Z�������  ��  ��  �   TO DO: sort this   � ��� "   T O   D O :   s o r t   t h i s� ���� L   b f�� c   b e��� o   b c���� 0 	theresult 	theResult� m   c d��
�� 
ctxt��  �'! note: AS treats `text`, `string`, and `Unicode text` as synonyms when comparing for equality, which is a little bit problematic as StdAdds' `read` command treats `string` as 'primary encoding' and `Unicode text` as UTF16; passing `primary encoding` for `using` parameter provides an 'out'   � ���B   n o t e :   A S   t r e a t s   ` t e x t ` ,   ` s t r i n g ` ,   a n d   ` U n i c o d e   t e x t `   a s   s y n o n y m s   w h e n   c o m p a r i n g   f o r   e q u a l i t y ,   w h i c h   i s   a   l i t t l e   b i t   p r o b l e m a t i c   a s   S t d A d d s '   ` r e a d `   c o m m a n d   t r e a t s   ` s t r i n g `   a s   ' p r i m a r y   e n c o d i n g '   a n d   ` U n i c o d e   t e x t `   a s   U T F 1 6 ;   p a s s i n g   ` p r i m a r y   e n c o d i n g `   f o r   ` u s i n g `   p a r a m e t e r   p r o v i d e s   a n   ' o u t '�  � k   i ��� ��� r   i t��� I  i r�����
�� .rdwropenshor       file� l  i n������ c   i n��� o   i j���� 0 	posixpath 	posixPath� m   j m��
�� 
psxf��  ��  ��  � o      ���� 0 fh  � ���� Q   u ����� k   x ��� ��� l  x ����� r   x ���� I  x �����
�� .rdwrread****        ****� o   x y���� 0 fh  � �����
�� 
as  � o   | }���� 0 datatype dataType��  � o      ���� 0 	theresult 	theResult� r l TO DO: how to produce better error messages (e.g. passing wrong dataType just gives 'Parameter error.' -50)   � ��� �   T O   D O :   h o w   t o   p r o d u c e   b e t t e r   e r r o r   m e s s a g e s   ( e . g .   p a s s i n g   w r o n g   d a t a T y p e   j u s t   g i v e s   ' P a r a m e t e r   e r r o r . '   - 5 0 )� ��� I  � ������
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
erob� o   � ����� 0 efrom eFrom� �����
�� 
errt� o   � ����� 
0 eto eTo��  ��  ��  �  g R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ��� 
�� 
erob� o      ���� 0 efrom eFrom  ����
�� 
errt o      ���� 
0 eto eTo��  h I   � ������� 
0 _error    m   � � �  r e a d   f i l e  o   � ����� 0 etext eText 	
	 o   � ����� 0 enumber eNumber
  o   � ����� 0 efrom eFrom �� o   � ����� 
0 eto eTo��  ��  X  l     ��������  ��  ��    l     ��������  ��  ��    i  . 1 I     ��
�� .Fil:Writnull���     file o      ���� 0 thefile theFile ��
�� 
Data o      ���� 0 thedata theData ��
�� 
Type |��������  ��   o      ���� 0 datatype dataType��   l     ���� m      ��
�� 
ctxt��  ��   ����
�� 
Enco |���� ��!��  ��    o      ���� 0 textencoding textEncoding��  ! l     "����" m      ��
�� FEncFE01��  ��  ��   Q     �#$%# k    �&& '(' r    )*) n   +,+ I    ��-���� ,0 asposixpathparameter asPOSIXPathParameter- ./. o    	���� 0 thefile theFile/ 0��0 m   	 
11 �22  ��  ��  , o    ���� 0 _supportlib _supportLib* o      ���� 0 	posixpath 	posixPath( 343 r    565 n   787 I    ��9���� "0 astypeparameter asTypeParameter9 :;: o    ���� 0 datatype dataType; <��< m    == �>>  a s��  ��  8 o    �� 0 _supportlib _supportLib6 o      �~�~ 0 datatype dataType4 ?�}? Z    �@A�|B@ F    *CDC =   "EFE o     �{�{ 0 datatype dataTypeF m     !�z
�z 
ctxtD >  % (GHG o   % &�y�y 0 textencoding textEncodingH m   & '�x
�x FEncFEPEA k   - vII JKJ r   - ALML n  - ?NON I   0 ?�wP�v�w &0 stringwithstring_ stringWithString_P Q�uQ l  0 ;R�t�sR n  0 ;STS I   5 ;�rU�q�r "0 astextparameter asTextParameterU VWV o   5 6�p�p 0 thedata theDataW X�oX m   6 7YY �ZZ  d a t a�o  �q  T o   0 5�n�n 0 _supportlib _supportLib�t  �s  �u  �v  O n  - 0[\[ o   . 0�m�m 0 nsstring NSString\ m   - .�l
�l misccuraM o      �k�k 0 
asocstring 
asocStringK ]^] r   B N_`_ n  B Laba I   G L�jc�i�j 0 getencoding getEncodingc d�hd o   G H�g�g 0 textencoding textEncoding�h  �i  b o   B G�f�f (0 _nsstringencodings _NSStringEncodings` o      �e�e 0 textencoding textEncoding^ efe l  O Xghig r   O Xjkj N   O Vll n   O Umnm 4   R U�do
�d 
cobjo m   S T�c�c n J   O Rpp q�bq m   O P�a
�a 
msng�b  k o      �`�` 0 errorref errorRefh   TO DO   i �rr    T O   D Of s�_s Z   Y vtu�^�]t H   Y cvv l  Y bw�\�[w n  Y bxyx I   Z b�Zz�Y�Z P0 &writetofile_atomically_encoding_error_ &writeToFile_atomically_encoding_error_z {|{ o   Z [�X�X 0 	posixpath 	posixPath| }~} m   [ \�W
�W boovtrue~ � o   \ ]�V�V 0 textencoding textEncoding� ��U� o   ] ^�T�T 0 errorref errorRef�U  �Y  y o   Y Z�S�S 0 
asocstring 
asocString�\  �[  u l  f r���� R   f r�R��
�R .ascrerr ****      � ****� m   n q�� ��� * F a i l e d   t o   w r i t e   f i l e .� �Q��P
�Q 
errn� m   j m�O�O��P  �   TO DO: sort this   � ��� "   T O   D O :   s o r t   t h i s�^  �]  �_  �|  B k   y ��� ��� r   y ���� I  y ��N��
�N .rdwropenshor       file� l  y ~��M�L� c   y ~��� o   y z�K�K 0 	posixpath 	posixPath� m   z }�J
�J 
psxf�M  �L  � �I��H
�I 
perm� m   � ��G
�G boovtrue�H  � o      �F�F 0 fh  � ��E� Q   � ����� k   � ��� ��� l  � ����� I  � ��D��
�D .rdwrseofnull���     ****� o   � ��C�C 0 fh  � �B��A
�B 
set2� m   � ��@�@  �A  � e _ important: when overwriting an existing file, make sure its previous contents are erased first   � ��� �   i m p o r t a n t :   w h e n   o v e r w r i t i n g   a n   e x i s t i n g   f i l e ,   m a k e   s u r e   i t s   p r e v i o u s   c o n t e n t s   a r e   e r a s e d   f i r s t� ��� l  � ����� I  � ��?��
�? .rdwrwritnull���     ****� o   � ��>�> 0 thedata theData� �=��
�= 
refn� o   � ��<�< 0 fh  � �;��:
�; 
as  � o   � ��9�9 0 datatype dataType�:  � 2 , TO DO: how to produce better error messages   � ��� X   T O   D O :   h o w   t o   p r o d u c e   b e t t e r   e r r o r   m e s s a g e s� ��� I  � ��8��7
�8 .rdwrclosnull���     ****� o   � ��6�6 0 fh  �7  � ��5� L   � ��� o   � ��4�4 0 	theresult 	theResult�5  � R      �3��
�3 .ascrerr ****      � ****� o      �2�2 0 etext eText� �1��
�1 
errn� o      �0�0 0 enumber eNumber� �/��
�/ 
erob� o      �.�. 0 efrom eFrom� �-��,
�- 
errt� o      �+�+ 
0 eto eTo�,  � k   � ��� ��� Q   � ����*� I  � ��)��(
�) .rdwrclosnull���     ****� o   � ��'�' 0 fh  �(  � R      �&�%�$
�& .ascrerr ****      � ****�%  �$  �*  � ��#� R   � ��"��
�" .ascrerr ****      � ****� o   � ��!�! 0 etext eText� � ��
�  
errn� o   � ��� 0 enumber eNumber� ���
� 
erob� o   � ��� 0 efrom eFrom� ���
� 
errt� o   � ��� 
0 eto eTo�  �#  �E  �}  $ R      ���
� .ascrerr ****      � ****� o      �� 0 etext eText� ���
� 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      �� 0 efrom eFrom� ���
� 
errt� o      �� 
0 eto eTo�  % I   � ����� 
0 _error  � ��� m   � ��� ���  w r i t e   f i l e� ��� o   � ��� 0 etext eText� ��� o   � ��� 0 enumber eNumber� ��� o   � ��� 0 efrom eFrom� ��� o   � ��
�
 
0 eto eTo�  �   ��� l     �	���	  �  �  � ��� l     ����  �  �  � ��� l     ����  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ����  �   POSIX path manipulation   � ��� 0   P O S I X   p a t h   m a n i p u l a t i o n� ��� l     �� ���  �   ��  � ��� i  2 5��� I     ����
�� .Fil:ConPnull���     ****� o      ���� 0 filepath filePath� ����
�� 
From� |����������  ��  � o      ���� 0 
fromformat 
fromFormat��  � l     ������ m      ��
�� FLCTFLCP��  ��  � �����
�� 
To__� |����������  ��  � o      ���� 0 toformat toFormat��  � l     ������ m      ��
�� FLCTFLCP��  ��  ��  � l   ����� Q    ��� � k     Z    ��� =     l   	����	 I   ��

�� .corecnte****       ****
 J     �� o    ���� 0 filepath filePath��   ����
�� 
kocl m    ��
�� 
ctxt��  ��  ��   m    ����   l    r     n    I    ������ ,0 asposixpathparameter asPOSIXPathParameter  o    ���� 0 filepath filePath �� m     �  ��  ��   o    ���� 0 _supportlib _supportLib o      ���� 0 	posixpath 	posixPath F @ assume it's a file identifier object (alias, �class furl�, etc)    � �   a s s u m e   i t ' s   a   f i l e   i d e n t i f i e r   o b j e c t   ( a l i a s ,   � c l a s s   f u r l � ,   e t c )��   l  ! � Z   ! � !"#  =  ! $$%$ o   ! "���� 0 
fromformat 
fromFormat% m   " #��
�� FLCTFLCP! r   ' *&'& o   ' (���� 0 filepath filePath' o      ���� 0 	posixpath 	posixPath" ()( =  - 0*+* o   - .���� 0 
fromformat 
fromFormat+ m   . /��
�� FLCTFLCH) ,-, l  3 ;./0. r   3 ;121 n   3 9343 1   7 9��
�� 
psxp4 l  3 75����5 4   3 7��6
�� 
file6 o   5 6���� 0 filepath filePath��  ��  2 o      ���� 0 	posixpath 	posixPath/ � � caution: HFS path format is flawed and deprecated everywhere else in OS X (unlike POSIX path format, it can't distinguish between two volumes with the same name), but is still used by AS and a few older scriptable apps so must be supported   0 �77�   c a u t i o n :   H F S   p a t h   f o r m a t   i s   f l a w e d   a n d   d e p r e c a t e d   e v e r y w h e r e   e l s e   i n   O S   X   ( u n l i k e   P O S I X   p a t h   f o r m a t ,   i t   c a n ' t   d i s t i n g u i s h   b e t w e e n   t w o   v o l u m e s   w i t h   t h e   s a m e   n a m e ) ,   b u t   i s   s t i l l   u s e d   b y   A S   a n d   a   f e w   o l d e r   s c r i p t a b l e   a p p s   s o   m u s t   b e   s u p p o r t e d- 898 =  > A:;: o   > ?���� 0 
fromformat 
fromFormat; m   ? @��
�� FLCTFLCW9 <=< l  D H>?@> R   D H��A��
�� .ascrerr ****      � ****A m   F GBB �CC ^ T O D O :   W i n d o w s   p a t h   c o n v e r s i o n   n o t   y e t   s u p p o r t e d��  ? W Q CFURLCreateWithFileSystemPath(NULL,(CFStringRef)path,kCFURLWindowsPathStyle,0);    @ �DD �   C F U R L C r e a t e W i t h F i l e S y s t e m P a t h ( N U L L , ( C F S t r i n g R e f ) p a t h , k C F U R L W i n d o w s P a t h S t y l e , 0 ) ;  = EFE =  K NGHG o   K L���� 0 
fromformat 
fromFormatH m   L M��
�� FLCTFLCUF I��I k   Q �JJ KLK r   Q [MNM n  Q YOPO I   T Y��Q����  0 urlwithstring_ URLWithString_Q R��R o   T U���� 0 filepath filePath��  ��  P n  Q TSTS o   R T���� 0 nsurl NSURLT m   Q R��
�� misccuraN o      ���� 0 asocurl asocURLL U��U Z  \ �VW����V G   \ lXYX =  \ _Z[Z o   \ ]���� 0 asocurl asocURL[ m   ] ^��
�� 
msngY H   b h\\ n  b g]^] I   c g�������� 0 fileurl fileURL��  ��  ^ o   b c���� 0 asocurl asocURLW R   o ���_`
�� .ascrerr ****      � ****_ m   } �aa �bb T I n v a l i d   d i r e c t   p a r a m e t e r   ( n o t   a   f i l e   U R L ) .` ��cd
�� 
errnc m   s v�����Yd ��e��
�� 
erobe o   y z���� 0 filepath filePath��  ��  ��  ��  ��  # R   � ���fg
�� .ascrerr ****      � ****f m   � �hh �ii f I n v a l i d    f r o m    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .g ��jk
�� 
errnj m   � ������Yk ��lm
�� 
erobl o   � ����� 0 
fromformat 
fromFormatm ��n��
�� 
errtn m   � ���
�� 
enum��   \ V it's a text path in the user-specified format, so convert it to a standard POSIX path    �oo �   i t ' s   a   t e x t   p a t h   i n   t h e   u s e r - s p e c i f i e d   f o r m a t ,   s o   c o n v e r t   i t   t o   a   s t a n d a r d   P O S I X   p a t h pqp l  � ���rs��  r   sanity check   s �tt    s a n i t y   c h e c kq uvu l  � �wxyw Z  � �z{����z =   � �|}| n  � �~~ 1   � ���
�� 
leng o   � ����� 0 	posixpath 	posixPath} m   � �����  { R   � �����
�� .ascrerr ****      � ****� m   � ��� ��� L I n v a l i d   d i r e c t   p a r a m e t e r   ( e m p t y   p a t h ) .� ����
�� 
errn� m   � ������Y� �����
�� 
erob� o   � ����� 0 filepath filePath��  ��  ��  x B < TO DO: what, if any, additional validation to perform here?   y ��� x   T O   D O :   w h a t ,   i f   a n y ,   a d d i t i o n a l   v a l i d a t i o n   t o   p e r f o r m   h e r e ?v ��� l  � �������  � ; 5 convert POSIX path text to the requested format/type   � ��� j   c o n v e r t   P O S I X   p a t h   t e x t   t o   t h e   r e q u e s t e d   f o r m a t / t y p e� ���� Z   ������ =  � ���� o   � ����� 0 toformat toFormat� m   � ���
�� FLCTFLCP� L   � ��� o   � ����� 0 	posixpath 	posixPath� ��� =  � ���� o   � ����� 0 toformat toFormat� m   � ���
�� FLCTFLCA� ��� l  � ����� L   � ��� c   � ���� c   � ���� o   � ����� 0 	posixpath 	posixPath� m   � ���
�� 
psxf� m   � ���
�� 
alis� %  returns object of type `alias`   � ��� >   r e t u r n s   o b j e c t   o f   t y p e   ` a l i a s `� ��� =  � ���� o   � ����� 0 toformat toFormat� m   � ���
�� FLCTFLCX� ��� l  � ����� L   � ��� c   � ���� o   � ����� 0 	posixpath 	posixPath� m   � ���
�� 
psxf� , & returns object of type `�class furl�`   � ��� L   r e t u r n s   o b j e c t   o f   t y p e   ` � c l a s s   f u r l � `� ��� =  � ���� o   � ����� 0 toformat toFormat� m   � ���
�� FLCTFLCS� ��� l  �	���� L   �	�� N   ��� n   ���� 4   ����
�� 
file� l  ������� c   ���� c   ���� o   � ���� 0 	posixpath 	posixPath� m   ��
�� 
psxf� m  ��
�� 
ctxt��  ��  � 1   � ���
�� 
ascr�NH returns an _object specifier_ of type 'file'. Caution: unlike alias and �class furl� objects, this is not a true object but may be used by some applications; not to be confused with the deprecated `file specifier` type (�class fss�), although it uses the same `file TEXT` constructor. Furthermore, it uses an HFS path string so suffers the same problems as HFS paths. Also, being a specifier, requires disambiguation when used [e.g.] in an `open` command otherwise command will be dispatched to it instead of target app, e.g. `tell app "TextEdit" to open {fileSpecifierObject}`. Horribly nasty, brittle, and confusing mis-feature, in other words, but supported (though not encouraged) as an option here for sake of compatibility as there's usually some scriptable app or other API in AS that will absolutely refuse to accept anything else.   � ����   r e t u r n s   a n   _ o b j e c t   s p e c i f i e r _   o f   t y p e   ' f i l e ' .   C a u t i o n :   u n l i k e   a l i a s   a n d   � c l a s s   f u r l �   o b j e c t s ,   t h i s   i s   n o t   a   t r u e   o b j e c t   b u t   m a y   b e   u s e d   b y   s o m e   a p p l i c a t i o n s ;   n o t   t o   b e   c o n f u s e d   w i t h   t h e   d e p r e c a t e d   ` f i l e   s p e c i f i e r `   t y p e   ( � c l a s s   f s s � ) ,   a l t h o u g h   i t   u s e s   t h e   s a m e   ` f i l e   T E X T `   c o n s t r u c t o r .   F u r t h e r m o r e ,   i t   u s e s   a n   H F S   p a t h   s t r i n g   s o   s u f f e r s   t h e   s a m e   p r o b l e m s   a s   H F S   p a t h s .   A l s o ,   b e i n g   a   s p e c i f i e r ,   r e q u i r e s   d i s a m b i g u a t i o n   w h e n   u s e d   [ e . g . ]   i n   a n   ` o p e n `   c o m m a n d   o t h e r w i s e   c o m m a n d   w i l l   b e   d i s p a t c h e d   t o   i t   i n s t e a d   o f   t a r g e t   a p p ,   e . g .   ` t e l l   a p p   " T e x t E d i t "   t o   o p e n   { f i l e S p e c i f i e r O b j e c t } ` .   H o r r i b l y   n a s t y ,   b r i t t l e ,   a n d   c o n f u s i n g   m i s - f e a t u r e ,   i n   o t h e r   w o r d s ,   b u t   s u p p o r t e d   ( t h o u g h   n o t   e n c o u r a g e d )   a s   a n   o p t i o n   h e r e   f o r   s a k e   o f   c o m p a t i b i l i t y   a s   t h e r e ' s   u s u a l l y   s o m e   s c r i p t a b l e   a p p   o r   o t h e r   A P I   i n   A S   t h a t   w i l l   a b s o l u t e l y   r e f u s e   t o   a c c e p t   a n y t h i n g   e l s e .� ��� = ��� o  ���� 0 toformat toFormat� m  ��
�� FLCTFLCH� ��� L  �� c  ��� c  ��� o  ���� 0 	posixpath 	posixPath� m  ��
�� 
psxf� m  ��
�� 
ctxt� ��� =  ��� o  ���� 0 toformat toFormat� m  ��
�� FLCTFLCW� ��� l #)���� R  #)����
�� .ascrerr ****      � ****� m  %(�� ��� ^ T O D O :   W i n d o w s   p a t h   c o n v e r s i o n   n o t   y e t   s u p p o r t e d�  � F @ CFURLCopyFileSystemPath((CFURLRef)url, kCFURLWindowsPathStyle);   � ��� �   C F U R L C o p y F i l e S y s t e m P a t h ( ( C F U R L R e f ) u r l ,   k C F U R L W i n d o w s P a t h S t y l e ) ;� ��� = ,/��� o  ,-�~�~ 0 toformat toFormat� m  -.�}
�} FLCTFLCU� ��|� k  2d�� ��� r  2<��� n 2:��� I  5:�{��z�{ $0 fileurlwithpath_ fileURLWithPath_� ��y� o  56�x�x 0 	posixpath 	posixPath�y  �z  � n 25��� o  35�w�w 0 nsurl NSURL� m  23�v
�v misccura� o      �u�u 0 asocurl asocURL� ��� Z  =[���t�s� = =@��� o  =>�r�r 0 asocurl asocURL� m  >?�q
�q 
msng� R  CW�p��
�p .ascrerr ****      � ****� b  QV��� m  QT�� ��� f C o u l d n ' t   c o n v e r t   t h e   f o l l o w i n g   p a t h   t o   a   f i l e   U R L :  � o  TU�o�o 0 	posixpath 	posixPath� �n��
�n 
errn� m  GJ�m�m�Y� �l��k
�l 
erob� o  MN�j�j 0 filepath filePath�k  �t  �s  � ��i� L  \d�� c  \c��� l \a �h�g  n \a I  ]a�f�e�d�f  0 absolutestring absoluteString�e  �d   o  \]�c�c 0 asocurl asocURL�h  �g  � m  ab�b
�b 
ctxt�i  �|  � R  g�a
�a .ascrerr ****      � **** m  {~ � b I n v a l i d    t o    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) . �`
�` 
errn m  kn�_�_�Y �^	

�^ 
erob	 o  qr�]�] 0 toformat toFormat
 �\�[
�\ 
errt m  ux�Z
�Z 
enum�[  ��  � R      �Y
�Y .ascrerr ****      � **** o      �X�X 0 etext eText �W
�W 
errn o      �V�V 0 enumber eNumber �U
�U 
erob o      �T�T 0 efrom eFrom �S�R
�S 
errt o      �Q�Q 
0 eto eTo�R    I  ���P�O�P 
0 _error    m  �� �  c o n v e r t   p a t h  o  ���N�N 0 etext eText  o  ���M�M 0 enumber eNumber  o  ���L�L 0 efrom eFrom �K o  ���J�J 
0 eto eTo�K  �O  � x r brings a modicum of sanity to the horrible mess that is AppleScript's file path formats and file identifier types   � � �   b r i n g s   a   m o d i c u m   o f   s a n i t y   t o   t h e   h o r r i b l e   m e s s   t h a t   i s   A p p l e S c r i p t ' s   f i l e   p a t h   f o r m a t s   a n d   f i l e   i d e n t i f i e r   t y p e s�  !  l     �I�H�G�I  �H  �G  ! "#" l     �F�E�D�F  �E  �D  # $%$ i  6 9&'& I     �C(�B
�C .Fil:NorPnull���     ****( o      �A�A 0 filepath filePath�B  ' Q     2)*+) k     ,, -.- r    /0/ n   121 I    �@3�?�@ ,0 asposixpathparameter asPOSIXPathParameter3 454 o    	�>�> 0 filepath filePath5 6�=6 m   	 
77 �88  �=  �?  2 o    �<�< 0 _supportlib _supportLib0 o      �;�; 0 filepath filePath. 9�:9 L     :: c    ;<; l   =�9�8= n   >?> I    �7�6�5�7 60 stringbystandardizingpath stringByStandardizingPath�6  �5  ? l   @�4�3@ n   ABA I    �2C�1�2 &0 stringwithstring_ stringWithString_C D�0D o    �/�/ 0 filepath filePath�0  �1  B n   EFE o    �.�. 0 nsstring NSStringF m    �-
�- misccura�4  �3  �9  �8  < m    �,
�, 
ctxt�:  * R      �+GH
�+ .ascrerr ****      � ****G o      �*�* 0 etext eTextH �)IJ
�) 
errnI o      �(�( 0 enumber eNumberJ �'KL
�' 
erobK o      �&�& 0 efrom eFromL �%M�$
�% 
errtM o      �#�# 
0 eto eTo�$  + I   ( 2�"N�!�" 
0 _error  N OPO m   ) *QQ �RR  n o r m a l i z e   p a t hP STS o   * +� �  0 etext eTextT UVU o   + ,�� 0 enumber eNumberV WXW o   , -�� 0 efrom eFromX Y�Y o   - .�� 
0 eto eTo�  �!  % Z[Z l     ����  �  �  [ \]\ l     ����  �  �  ] ^_^ i  : =`a` I     �bc
� .Fil:JoiPnull���     ****b o      ��  0 pathcomponents pathComponentsc �d�
� 
Exted |��e�f�  �  e o      �� 0 fileextension fileExtension�  f l     g��g m      �
� 
msng�  �  �  a Q     �hijh k    �kk lml r    non n    pqp 2   �

�
 
cobjq n   rsr I    �	t��	 "0 aslistparameter asListParametert uvu o    	��  0 pathcomponents pathComponentsv w�w m   	 
xx �yy  �  �  s o    �� 0 _supportlib _supportLibo o      �� 0 subpaths subPathsm z{z Q    \|}~| k    L ��� Z   %����� =   ��� o    �� 0 subpaths subPaths� J    � �   � R    !������
�� .ascrerr ****      � ****��  ��  �  �  � ���� X   & L����� l  6 G���� r   6 G��� n  6 C��� I   ; C������� ,0 asposixpathparameter asPOSIXPathParameter� ��� n  ; >��� 1   < >��
�� 
pcnt� o   ; <���� 0 aref aRef� ���� m   > ?�� ���  ��  ��  � o   6 ;���� 0 _supportlib _supportLib� n     ��� 1   D F��
�� 
pcnt� o   C D���� 0 aref aRef� | v TO DO: how should absolute paths after first item get handled? (e.g. Python's os.path.join discards everything prior)   � ��� �   T O   D O :   h o w   s h o u l d   a b s o l u t e   p a t h s   a f t e r   f i r s t   i t e m   g e t   h a n d l e d ?   ( e . g .   P y t h o n ' s   o s . p a t h . j o i n   d i s c a r d s   e v e r y t h i n g   p r i o r )�� 0 aref aRef� o   ) *���� 0 subpaths subPaths��  } R      ������
�� .ascrerr ****      � ****��  ��  ~ R   T \����
�� .ascrerr ****      � ****� m   Z [�� ��� � I n v a l i d   p a t h   c o m p o n e n t s   l i s t   ( e x p e c t e d   o n e   o r   m o r e   t e x t   a n d / o r   f i l e   i t e m s ) .� ����
�� 
errn� m   V W�����Y� �����
�� 
erob� o   X Y����  0 pathcomponents pathComponents��  { ��� r   ] i��� l  ] g������ n  ] g��� I   b g������� *0 pathwithcomponents_ pathWithComponents_� ���� o   b c���� 0 subpaths subPaths��  ��  � n  ] b��� o   ^ b���� 0 nsstring NSString� m   ] ^��
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
ctxt��  i R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  j I   � �������� 
0 _error  � ��� m   � ��� ���  j o i n   p a t h� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  _ ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  > A��� I     ����
�� .Fil:SplPnull���     ctxt� o      ���� 0 filepath filePath� �����
�� 
Upon� |����������  ��  � o      ���� 0 splitposition splitPosition��  � l     ������ m      ��
�� FLSPFLSL��  ��  ��  � Q     ��� � k    s  r     n    I    ������ &0 stringwithstring_ stringWithString_ 	��	 l   
����
 n    I    ������ ,0 asposixpathparameter asPOSIXPathParameter  o    ���� 0 filepath filePath �� m     �  ��  ��   o    ���� 0 _supportlib _supportLib��  ��  ��  ��   n    o    ���� 0 nsstring NSString m    ��
�� misccura o      ���� 0 asocpath asocPath �� Z    s =    o    ���� 0 splitposition splitPosition m    ��
�� FLSPFLSL L    / J    .  c    % !  l   #"����" n   ##$# I    #�������� F0 !stringbydeletinglastpathcomponent !stringByDeletingLastPathComponent��  ��  $ o    ���� 0 asocpath asocPath��  ��  ! m   # $��
�� 
ctxt %��% c   % ,&'& l  % *(����( n  % *)*) I   & *�������� &0 lastpathcomponent lastPathComponent��  ��  * o   % &���� 0 asocpath asocPath��  ��  ' m   * +��
�� 
ctxt��   +,+ =  2 5-.- o   2 3���� 0 splitposition splitPosition. m   3 4�
� FLSPFLSE, /0/ L   8 I11 J   8 H22 343 c   8 ?565 l  8 =7�~�}7 n  8 =898 I   9 =�|�{�z�| >0 stringbydeletingpathextension stringByDeletingPathExtension�{  �z  9 o   8 9�y�y 0 asocpath asocPath�~  �}  6 m   = >�x
�x 
ctxt4 :�w: c   ? F;<; l  ? D=�v�u= n  ? D>?> I   @ D�t�s�r�t 0 pathextension pathExtension�s  �r  ? o   ? @�q�q 0 asocpath asocPath�v  �u  < m   D E�p
�p 
ctxt�w  0 @A@ =  L OBCB o   L M�o�o 0 splitposition splitPositionC m   M N�n
�n FLSPFLSAA D�mD L   R ZEE c   R YFGF l  R WH�l�kH n  R WIJI I   S W�j�i�h�j  0 pathcomponents pathComponents�i  �h  J o   R S�g�g 0 asocpath asocPath�l  �k  G m   W X�f
�f 
list�m   R   ] s�eKL
�e .ascrerr ****      � ****K m   o rMM �NN b I n v a l i d    a t    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .L �dOP
�d 
errnO m   _ b�c�c�YP �bQR
�b 
erobQ o   e f�a�a 0 matchformat matchFormatR �`S�_
�` 
errtS m   i l�^
�^ 
enum�_  ��  � R      �]TU
�] .ascrerr ****      � ****T o      �\�\ 0 etext eTextU �[VW
�[ 
errnV o      �Z�Z 0 enumber eNumberW �YXY
�Y 
erobX o      �X�X 0 efrom eFromY �WZ�V
�W 
errtZ o      �U�U 
0 eto eTo�V    I   { ��T[�S�T 
0 _error  [ \]\ m   | ^^ �__  s p l i t   p a t h] `a` o    ��R�R 0 etext eTexta bcb o   � ��Q�Q 0 enumber eNumberc ded o   � ��P�P 0 efrom eFrome f�Of o   � ��N�N 
0 eto eTo�O  �S  � ghg l     �M�L�K�M  �L  �K  h i�Ji l     �I�H�G�I  �H  �G  �J       �Fjklmnopqrst�F  j 
�E�D�C�B�A�@�?�>�=�<
�E 
pimr�D 0 _supportlib _supportLib�C 
0 _error  �B (0 _nsstringencodings _NSStringEncodings
�A .Fil:Readnull���     file
�@ .Fil:Writnull���     file
�? .Fil:ConPnull���     ****
�> .Fil:NorPnull���     ****
�= .Fil:JoiPnull���     ****
�< .Fil:SplPnull���     ctxtk �;u�; u  vwv �:x�9
�: 
cobjx yy   �8 
�8 
frmk�9  w �7z�6
�7 
cobjz {{   �5
�5 
osax�6  l ||   �4 +
�4 
scptm �3 5�2�1}~�0�3 
0 _error  �2 �/�/   �.�-�,�+�*�. 0 handlername handlerName�- 0 etext eText�, 0 enumber eNumber�+ 0 efrom eFrom�* 
0 eto eTo�1  } �)�(�'�&�%�) 0 handlername handlerName�( 0 etext eText�' 0 enumber eNumber�& 0 efrom eFrom�% 
0 eto eTo~  E�$�#�$ �# &0 throwcommanderror throwCommandError�0 b  ࠡ����+ n �" b  ��" (0 _nsstringencodings _NSStringEncodings�  ���� �!� �! 
0 _list_  �  0 getencoding getEncoding� ��� �  ���������������������� ��� �  ��
� FEncFE01� � ��� �  ��
� FEncFE02� 
� ��� �  � �
� FEncFE03� ��� �  � �
� FEncFE04� ��� �  � �
� FEncFE05� ��� �  � �
� FEncFE06� ��� �  � �
� FEncFE07� ��� �  ��
� FEncFE11� � ��� �  �
�	
�
 FEncFE12�	 � ��� �  ��
� FEncFE13� � ��� �  ��
� FEncFE14� 	� ��� �  �� 
� FEncFE15�  � ����� �  ����
�� FEncFE16�� � ����� �  ����
�� FEncFE17�� � ����� �  ����
�� FEncFE18�� � ����� �  ����
�� FEncFE19�� � ����� �  ����
�� FEncFE50�� � ����� �  ����
�� FEncFE51�� � ����� �  ����
�� FEncFE52�� � ����� �  ����
�� FEncFE53�� � ����� �  ����
�� FEncFE54�� � ������������ 0 getencoding getEncoding�� ����� �  ���� 0 textencoding textEncoding��  � ������ 0 textencoding textEncoding�� 0 aref aRef� �������������������������>
�� 
enum�� 
0 _list_  
�� 
kocl
�� 
cobj
�� .corecnte****       ****��  � ������
�� 
errn���\��  
�� 
long
�� 
errn���Y
�� 
erob
�� 
errt�� �� W 5��&E�O ))�,[��l kh ��k/�  ��l/EY h[OY��W X   	��&W X  hO)�������o ��Z��������
�� .Fil:Readnull���     file�� 0 thefile theFile�� ����
�� 
Type� {�������� 0 datatype dataType��  
�� 
ctxt� �����
�� 
Enco� {�������� 0 textencoding textEncoding��  
�� FEncFE01��  � ������������������������ 0 thefile theFile�� 0 datatype dataType�� 0 textencoding textEncoding�� 0 	posixpath 	posixPath�� 0 errorref errorRef�� 0 	theresult 	theResult�� 0 fh  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� t��������������������������������������������������������� ,0 asposixpathparameter asPOSIXPathParameter�� "0 astypeparameter asTypeParameter
�� 
ctxt
�� FEncFEPE
�� 
bool�� 0 getencoding getEncoding
�� 
msng
�� 
cobj
�� misccura�� 0 nsstring NSString�� T0 (stringwithcontentsoffile_encoding_error_ (stringWithContentsOfFile_encoding_error_
�� 
errn���
�� 
psxf
�� .rdwropenshor       file
�� 
as  
�� .rdwrread****        ****
�� .rdwrclosnull���     ****�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  ��  ��  
�� 
erob
�� 
errt�� �� �� 
0 _error  �� � �b  ��l+ E�Ob  ��l+ E�O�� 	 ���& >b  �k+ E�O�kv�k/E�O��,���m+ E�O��  )��l�Y hO��&Y O�a &j E�O �a �l E�O�j O�W )X   
�j W X  hO)��a �a �a �W X  *a ����a + p ����������
�� .Fil:Writnull���     file�� 0 thefile theFile�� �����
�� 
Data�� 0 thedata theData� ����
�� 
Type� {�������� 0 datatype dataType��  
�� 
ctxt� �����
�� 
Enco� {�������� 0 textencoding textEncoding��  
�� FEncFE01��  � ��������������~�}�|�{�z�y�� 0 thefile theFile�� 0 thedata theData�� 0 datatype dataType�� 0 textencoding textEncoding�� 0 	posixpath 	posixPath�� 0 
asocstring 
asocString� 0 errorref errorRef�~ 0 fh  �} 0 	theresult 	theResult�| 0 etext eText�{ 0 enumber eNumber�z 0 efrom eFrom�y 
0 eto eTo� '1�x=�w�v�u�t�s�rY�q�p�o�n�m�l�k�j�i��h�g�f�e�d�c�b�a�`�_��^�]�\�[�Z��Y�X�x ,0 asposixpathparameter asPOSIXPathParameter�w "0 astypeparameter asTypeParameter
�v 
ctxt
�u FEncFEPE
�t 
bool
�s misccura�r 0 nsstring NSString�q "0 astextparameter asTextParameter�p &0 stringwithstring_ stringWithString_�o 0 getencoding getEncoding
�n 
msng
�m 
cobj�l �k P0 &writetofile_atomically_encoding_error_ &writeToFile_atomically_encoding_error_
�j 
errn�i�
�h 
psxf
�g 
perm
�f .rdwropenshor       file
�e 
set2
�d .rdwrseofnull���     ****
�c 
refn
�b 
as  
�a .rdwrwritnull���     ****
�` .rdwrclosnull���     ****�_ 0 etext eText� �W�V�
�W 
errn�V 0 enumber eNumber� �U�T�
�U 
erob�T 0 efrom eFrom� �S�R�Q
�S 
errt�R 
0 eto eTo�Q  �^  �]  
�\ 
erob
�[ 
errt�Z �Y �X 
0 _error  �� � �b  ��l+ E�Ob  ��l+ E�O�� 	 ���& N��,b  ��l+ 
k+ E�Ob  �k+ E�O�kv�k/E�O��e���+  )a a la Y hY a�a &a el E�O %�a jl O�a �a �� O�j O�W +X   
�j W X   hO)a �a !�a "�a #�W X  *a $����a %+ &q �P��O�N���M
�P .Fil:ConPnull���     ****�O 0 filepath filePath�N �L��
�L 
From� {�K�J�I�K 0 
fromformat 
fromFormat�J  
�I FLCTFLCP� �H��G
�H 
To__� {�F�E�D�F 0 toformat toFormat�E  
�D FLCTFLCP�G  � 	�C�B�A�@�?�>�=�<�;�C 0 filepath filePath�B 0 
fromformat 
fromFormat�A 0 toformat toFormat�@ 0 	posixpath 	posixPath�? 0 asocurl asocURL�> 0 etext eText�= 0 enumber eNumber�< 0 efrom eFrom�; 
0 eto eTo� -�:�9�8�7�6�5�4�3�2B�1�0�/�.�-�,�+�*�)�(�'a�&�%�$h�#��"�!� �����������
�: 
kocl
�9 
ctxt
�8 .corecnte****       ****�7 ,0 asposixpathparameter asPOSIXPathParameter
�6 FLCTFLCP
�5 FLCTFLCH
�4 
file
�3 
psxp
�2 FLCTFLCW
�1 FLCTFLCU
�0 misccura�/ 0 nsurl NSURL�.  0 urlwithstring_ URLWithString_
�- 
msng�, 0 fileurl fileURL
�+ 
bool
�* 
errn�)�Y
�( 
erob�' 
�& 
errt
�% 
enum�$ 
�# 
leng
�" FLCTFLCA
�! 
psxf
�  
alis
� FLCTFLCX
� FLCTFLCS
� 
ascr� $0 fileurlwithpath_ fileURLWithPath_�  0 absolutestring absoluteString� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  �M���kv��l j  b  ��l+ E�Y ���  �E�Y u��  *�/�,E�Y d��  	)j�Y W��  9��,�k+ E�O�� 
 �j+ a & )a a a �a a Y hY )a a a �a a a a O�a ,j  )a a a �a a Y hO��  �Y ��a   �a &a &Y ��a    �a &Y ��a !  _ "�a &�&/Y u��  �a &�&Y d��  )ja #Y U��  7��,�k+ $E�O��  )a a a �a a %�%Y hO�j+ &�&Y )a a a �a a a a 'W X ( )*a *����a ++ ,r �'�����
� .Fil:NorPnull���     ****� 0 filepath filePath�  � ���
�	�� 0 filepath filePath� 0 etext eText�
 0 enumber eNumber�	 0 efrom eFrom� 
0 eto eTo� 7��������Q� ��� ,0 asposixpathparameter asPOSIXPathParameter
� misccura� 0 nsstring NSString� &0 stringwithstring_ stringWithString_� 60 stringbystandardizingpath stringByStandardizingPath
� 
ctxt� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �  �� 
0 _error  � 3 "b  ��l+ E�O��,�k+ j+ �&W X  *顢���+ s ��a��������
�� .Fil:JoiPnull���     ****��  0 pathcomponents pathComponents�� �����
�� 
Exte� {�������� 0 fileextension fileExtension��  
�� 
msng��  � 	��������������������  0 pathcomponents pathComponents�� 0 fileextension fileExtension�� 0 subpaths subPaths�� 0 aref aRef�� 0 asocpath asocPath�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� x���������������������������������������������������� "0 aslistparameter asListParameter
�� 
cobj
�� 
kocl
�� .corecnte****       ****
�� 
pcnt�� ,0 asposixpathparameter asPOSIXPathParameter��  ��  
�� 
errn���Y
�� 
erob�� 
�� misccura�� 0 nsstring NSString�� *0 pathwithcomponents_ pathWithComponents_
�� 
msng�� "0 astextparameter asTextParameter�� B0 stringbyappendingpathextension_ stringByAppendingPathExtension_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � �b  ��l+ �-E�O ;�jv  	)jhY hO %�[��l kh b  ��,�l+ ��,F[OY��W X  	)�����O�a ,�k+ E�O�a  4b  �a l+ E�O��k+ E�O�a   )����a Y hY hO�a &W X  *a ����a + t �����������
�� .Fil:SplPnull���     ctxt�� 0 filepath filePath�� �����
�� 
Upon� {�������� 0 splitposition splitPosition��  
�� FLSPFLSL��  � ������������������ 0 filepath filePath�� 0 splitposition splitPosition�� 0 asocpath asocPath�� 0 matchformat matchFormat�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ����������������������������������������M���^����
�� misccura�� 0 nsstring NSString�� ,0 asposixpathparameter asPOSIXPathParameter�� &0 stringwithstring_ stringWithString_
�� FLSPFLSL�� F0 !stringbydeletinglastpathcomponent !stringByDeletingLastPathComponent
�� 
ctxt�� &0 lastpathcomponent lastPathComponent
�� FLSPFLSE�� >0 stringbydeletingpathextension stringByDeletingPathExtension�� 0 pathextension pathExtension
�� FLSPFLSA��  0 pathcomponents pathComponents
�� 
list
�� 
errn���Y
�� 
erob
�� 
errt
�� 
enum�� �� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � u��,b  ��l+ k+ E�O��  �j+ �&�j+ �&lvY C��  �j+ 
�&�j+ �&lvY )��  �j+ �&Y )�a a �a a a a W X  *a ����a + ascr  ��ޭ