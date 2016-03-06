FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� Text -- commonly-used text processing commands

Notes: 

- When matching text item delimiters in text value, AppleScript uses the current scope's existing considering/ignoring case, diacriticals, hyphens, punctuation, white space and numeric strings settings; thus, wrapping a `search text` command in different considering/ignoring blocks can produce different results. For example, `search text "fud" for "F" will normally match the first character since AppleScript uses case-insensitive matching by default, whereas enclosing it in a `considering case` block will cause the same command to return zero matches. Conversely, `search text "f ud" for "fu"` will normally return zero matches as AppleScript considers white space by default, but when enclosed in an `ignoring white space` block will match the first three characters: "f u". This is how AppleScript is designed to work, but users need to be reminded of this as considering/ignoring blocks affect ALL script handlers called within that block, including nested calls (and all to any osax and application handlers that understand considering/ignoring attributes).

- Unlike AS text values, NSString and NSRegularExpression don't ignore normalization differences when comparing for equality, so `search text`, `split text`, etc. must normalize input and pattern text; this means that result text may have different normalization to input.


TO DO:

- decide if predefined considering/ignoring options in `search text`, etc. should consider or ignore diacriticals and numeric strings; once decided, use same combinations for List library's text comparator for consistency? (currently Text library's `case [in]sensitivity` options consider diacriticals for equality whereas List library ignores them for ordering)


- what about `normalize text` command that wraps NSString's stringByFoldingWithOptions:locale:? (e.g. for removing diacriticals); might also want to incorporate unicode normalization into this rather than having separate precompose/decompose commands

- implement `precompose/decompose characters TEXT [with/without compatibility mapping]` commands? One could argue this is just out of scope for stdlib as AS itself does the sensible thing when dealing with composed vs decomposed glyphs, treating them as logically equal. The problem is when AS interfaces with other systems that aren't (including shell and NSString), at which point AS code should normalize text before handing it off to ensure consistent behavior.

	- AS preserves composed vs decomposed unicode chars as-is (getting `id` produces different results) but is smart enough to compare them as equal; however, it doesn't normalize when reading/writing or crossing ASOC bridge so written files will vary and NSString (which is old-school UTF16) compares them as not-equal, so any operations involving NSString's `isEqual[ToString]:` will need to normalize both strings first to ensure consistent behavior using one of the following NSString methods:
	
		decomposedStringWithCanonicalMapping (Unicode Normalization Form D)
		decomposedStringWithCompatibilityMapping (Unicode Normalization Form KD)
		precomposedStringWithCanonicalMapping (Unicode Normalization Form C)
		precomposedStringWithCompatibilityMapping (Unicode Normalization Form KC)

 	- note that Satimage.osax provides a `normalize unicode` command, although it only covers 2 of 4 forms

- should `format text` support "\\n", "\\t", etc.? how should backslashed characters that are non-special be treated? (note that the template syntax is designed to be same as that used by `search text`, which uses NSRegularExpression's template syntax); need to give some thought to this, and whether a different escape character should be used throughout to avoid need for double backslashing (since AS already uses backslash as escape character in text literals), which is hard to read and error prone (downside is portability, as backslash escaping is already standard in regexps)


- fix inconsistencies: `split text`'s `at` parameter accepts a list of text separators for TID splitting, but not when pattern matching is used (simplest would be to join using "|"); also, `search text`'s `for` parameter doesn't allow list of text even though both commands are supposed to support same matching options for consistency

     � 	 	!�   T e x t   - -   c o m m o n l y - u s e d   t e x t   p r o c e s s i n g   c o m m a n d s 
 
 N o t e s :   
 
 -   W h e n   m a t c h i n g   t e x t   i t e m   d e l i m i t e r s   i n   t e x t   v a l u e ,   A p p l e S c r i p t   u s e s   t h e   c u r r e n t   s c o p e ' s   e x i s t i n g   c o n s i d e r i n g / i g n o r i n g   c a s e ,   d i a c r i t i c a l s ,   h y p h e n s ,   p u n c t u a t i o n ,   w h i t e   s p a c e   a n d   n u m e r i c   s t r i n g s   s e t t i n g s ;   t h u s ,   w r a p p i n g   a   ` s e a r c h   t e x t `   c o m m a n d   i n   d i f f e r e n t   c o n s i d e r i n g / i g n o r i n g   b l o c k s   c a n   p r o d u c e   d i f f e r e n t   r e s u l t s .   F o r   e x a m p l e ,   ` s e a r c h   t e x t   " f u d "   f o r   " F "   w i l l   n o r m a l l y   m a t c h   t h e   f i r s t   c h a r a c t e r   s i n c e   A p p l e S c r i p t   u s e s   c a s e - i n s e n s i t i v e   m a t c h i n g   b y   d e f a u l t ,   w h e r e a s   e n c l o s i n g   i t   i n   a   ` c o n s i d e r i n g   c a s e `   b l o c k   w i l l   c a u s e   t h e   s a m e   c o m m a n d   t o   r e t u r n   z e r o   m a t c h e s .   C o n v e r s e l y ,   ` s e a r c h   t e x t   " f   u d "   f o r   " f u " `   w i l l   n o r m a l l y   r e t u r n   z e r o   m a t c h e s   a s   A p p l e S c r i p t   c o n s i d e r s   w h i t e   s p a c e   b y   d e f a u l t ,   b u t   w h e n   e n c l o s e d   i n   a n   ` i g n o r i n g   w h i t e   s p a c e `   b l o c k   w i l l   m a t c h   t h e   f i r s t   t h r e e   c h a r a c t e r s :   " f   u " .   T h i s   i s   h o w   A p p l e S c r i p t   i s   d e s i g n e d   t o   w o r k ,   b u t   u s e r s   n e e d   t o   b e   r e m i n d e d   o f   t h i s   a s   c o n s i d e r i n g / i g n o r i n g   b l o c k s   a f f e c t   A L L   s c r i p t   h a n d l e r s   c a l l e d   w i t h i n   t h a t   b l o c k ,   i n c l u d i n g   n e s t e d   c a l l s   ( a n d   a l l   t o   a n y   o s a x   a n d   a p p l i c a t i o n   h a n d l e r s   t h a t   u n d e r s t a n d   c o n s i d e r i n g / i g n o r i n g   a t t r i b u t e s ) . 
 
 -   U n l i k e   A S   t e x t   v a l u e s ,   N S S t r i n g   a n d   N S R e g u l a r E x p r e s s i o n   d o n ' t   i g n o r e   n o r m a l i z a t i o n   d i f f e r e n c e s   w h e n   c o m p a r i n g   f o r   e q u a l i t y ,   s o   ` s e a r c h   t e x t ` ,   ` s p l i t   t e x t ` ,   e t c .   m u s t   n o r m a l i z e   i n p u t   a n d   p a t t e r n   t e x t ;   t h i s   m e a n s   t h a t   r e s u l t   t e x t   m a y   h a v e   d i f f e r e n t   n o r m a l i z a t i o n   t o   i n p u t . 
 
 
 T O   D O : 
 
 -   d e c i d e   i f   p r e d e f i n e d   c o n s i d e r i n g / i g n o r i n g   o p t i o n s   i n   ` s e a r c h   t e x t ` ,   e t c .   s h o u l d   c o n s i d e r   o r   i g n o r e   d i a c r i t i c a l s   a n d   n u m e r i c   s t r i n g s ;   o n c e   d e c i d e d ,   u s e   s a m e   c o m b i n a t i o n s   f o r   L i s t   l i b r a r y ' s   t e x t   c o m p a r a t o r   f o r   c o n s i s t e n c y ?   ( c u r r e n t l y   T e x t   l i b r a r y ' s   ` c a s e   [ i n ] s e n s i t i v i t y `   o p t i o n s   c o n s i d e r   d i a c r i t i c a l s   f o r   e q u a l i t y   w h e r e a s   L i s t   l i b r a r y   i g n o r e s   t h e m   f o r   o r d e r i n g ) 
 
 
 -   w h a t   a b o u t   ` n o r m a l i z e   t e x t `   c o m m a n d   t h a t   w r a p s   N S S t r i n g ' s   s t r i n g B y F o l d i n g W i t h O p t i o n s : l o c a l e : ?   ( e . g .   f o r   r e m o v i n g   d i a c r i t i c a l s ) ;   m i g h t   a l s o   w a n t   t o   i n c o r p o r a t e   u n i c o d e   n o r m a l i z a t i o n   i n t o   t h i s   r a t h e r   t h a n   h a v i n g   s e p a r a t e   p r e c o m p o s e / d e c o m p o s e   c o m m a n d s 
 
 -   i m p l e m e n t   ` p r e c o m p o s e / d e c o m p o s e   c h a r a c t e r s   T E X T   [ w i t h / w i t h o u t   c o m p a t i b i l i t y   m a p p i n g ] `   c o m m a n d s ?   O n e   c o u l d   a r g u e   t h i s   i s   j u s t   o u t   o f   s c o p e   f o r   s t d l i b   a s   A S   i t s e l f   d o e s   t h e   s e n s i b l e   t h i n g   w h e n   d e a l i n g   w i t h   c o m p o s e d   v s   d e c o m p o s e d   g l y p h s ,   t r e a t i n g   t h e m   a s   l o g i c a l l y   e q u a l .   T h e   p r o b l e m   i s   w h e n   A S   i n t e r f a c e s   w i t h   o t h e r   s y s t e m s   t h a t   a r e n ' t   ( i n c l u d i n g   s h e l l   a n d   N S S t r i n g ) ,   a t   w h i c h   p o i n t   A S   c o d e   s h o u l d   n o r m a l i z e   t e x t   b e f o r e   h a n d i n g   i t   o f f   t o   e n s u r e   c o n s i s t e n t   b e h a v i o r . 
 
 	 -   A S   p r e s e r v e s   c o m p o s e d   v s   d e c o m p o s e d   u n i c o d e   c h a r s   a s - i s   ( g e t t i n g   ` i d `   p r o d u c e s   d i f f e r e n t   r e s u l t s )   b u t   i s   s m a r t   e n o u g h   t o   c o m p a r e   t h e m   a s   e q u a l ;   h o w e v e r ,   i t   d o e s n ' t   n o r m a l i z e   w h e n   r e a d i n g / w r i t i n g   o r   c r o s s i n g   A S O C   b r i d g e   s o   w r i t t e n   f i l e s   w i l l   v a r y   a n d   N S S t r i n g   ( w h i c h   i s   o l d - s c h o o l   U T F 1 6 )   c o m p a r e s   t h e m   a s   n o t - e q u a l ,   s o   a n y   o p e r a t i o n s   i n v o l v i n g   N S S t r i n g ' s   ` i s E q u a l [ T o S t r i n g ] : `   w i l l   n e e d   t o   n o r m a l i z e   b o t h   s t r i n g s   f i r s t   t o   e n s u r e   c o n s i s t e n t   b e h a v i o r   u s i n g   o n e   o f   t h e   f o l l o w i n g   N S S t r i n g   m e t h o d s : 
 	 
 	 	 d e c o m p o s e d S t r i n g W i t h C a n o n i c a l M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   D ) 
 	 	 d e c o m p o s e d S t r i n g W i t h C o m p a t i b i l i t y M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   K D ) 
 	 	 p r e c o m p o s e d S t r i n g W i t h C a n o n i c a l M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   C ) 
 	 	 p r e c o m p o s e d S t r i n g W i t h C o m p a t i b i l i t y M a p p i n g   ( U n i c o d e   N o r m a l i z a t i o n   F o r m   K C ) 
 
   	 -   n o t e   t h a t   S a t i m a g e . o s a x   p r o v i d e s   a   ` n o r m a l i z e   u n i c o d e `   c o m m a n d ,   a l t h o u g h   i t   o n l y   c o v e r s   2   o f   4   f o r m s 
 
 -   s h o u l d   ` f o r m a t   t e x t `   s u p p o r t   " \ \ n " ,   " \ \ t " ,   e t c . ?   h o w   s h o u l d   b a c k s l a s h e d   c h a r a c t e r s   t h a t   a r e   n o n - s p e c i a l   b e   t r e a t e d ?   ( n o t e   t h a t   t h e   t e m p l a t e   s y n t a x   i s   d e s i g n e d   t o   b e   s a m e   a s   t h a t   u s e d   b y   ` s e a r c h   t e x t ` ,   w h i c h   u s e s   N S R e g u l a r E x p r e s s i o n ' s   t e m p l a t e   s y n t a x ) ;   n e e d   t o   g i v e   s o m e   t h o u g h t   t o   t h i s ,   a n d   w h e t h e r   a   d i f f e r e n t   e s c a p e   c h a r a c t e r   s h o u l d   b e   u s e d   t h r o u g h o u t   t o   a v o i d   n e e d   f o r   d o u b l e   b a c k s l a s h i n g   ( s i n c e   A S   a l r e a d y   u s e s   b a c k s l a s h   a s   e s c a p e   c h a r a c t e r   i n   t e x t   l i t e r a l s ) ,   w h i c h   i s   h a r d   t o   r e a d   a n d   e r r o r   p r o n e   ( d o w n s i d e   i s   p o r t a b i l i t y ,   a s   b a c k s l a s h   e s c a p i n g   i s   a l r e a d y   s t a n d a r d   i n   r e g e x p s ) 
 
 
 -   f i x   i n c o n s i s t e n c i e s :   ` s p l i t   t e x t ` ' s   ` a t `   p a r a m e t e r   a c c e p t s   a   l i s t   o f   t e x t   s e p a r a t o r s   f o r   T I D   s p l i t t i n g ,   b u t   n o t   w h e n   p a t t e r n   m a t c h i n g   i s   u s e d   ( s i m p l e s t   w o u l d   b e   t o   j o i n   u s i n g   " | " ) ;   a l s o ,   ` s e a r c h   t e x t ` ' s   ` f o r `   p a r a m e t e r   d o e s n ' t   a l l o w   l i s t   o f   t e x t   e v e n   t h o u g h   b o t h   c o m m a n d s   a r e   s u p p o s e d   t o   s u p p o r t   s a m e   m a t c h i n g   o p t i o n s   f o r   c o n s i s t e n c y 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��      record types     �      r e c o r d   t y p e s     !   l     ��������  ��  ��   !  " # " j    �� $�� (0 _unmatchedtexttype _UnmatchedTextType $ m    ��
�� 
TxtU #  % & % j    �� '�� $0 _matchedtexttype _MatchedTextType ' m    ��
�� 
TxtM &  ( ) ( j    �� *�� &0 _matchedgrouptype _MatchedGroupType * m    ��
�� 
TxtG )  + , + l     ��������  ��  ��   ,  - . - l     ��������  ��  ��   .  / 0 / l     �� 1 2��   1 J D--------------------------------------------------------------------    2 � 3 3 � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 0  4 5 4 l     �� 6 7��   6   support    7 � 8 8    s u p p o r t 5  9 : 9 l     ��������  ��  ��   :  ; < ; l      = > ? = j    �� @�� 0 _support   @ N     A A 4    �� B
�� 
scpt B m     C C � D D  T y p e S u p p o r t > "  used for parameter checking    ? � E E 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g <  F G F l     ��������  ��  ��   G  H I H l     ��������  ��  ��   I  J K J i    L M L I      �� N���� 
0 _error   N  O P O o      ���� 0 handlername handlerName P  Q R Q o      ���� 0 etext eText R  S T S o      ���� 0 enumber eNumber T  U V U o      ���� 0 efrom eFrom V  W�� W o      ���� 
0 eto eTo��  ��   M n     X Y X I    �� Z���� &0 throwcommanderror throwCommandError Z  [ \ [ m     ] ] � ^ ^  T e x t \  _ ` _ o    ���� 0 handlername handlerName `  a b a o    ���� 0 etext eText b  c d c o    	���� 0 enumber eNumber d  e f e o   	 
���� 0 efrom eFrom f  g�� g o   
 ���� 
0 eto eTo��  ��   Y o     ���� 0 _support   K  h i h l     ��������  ��  ��   i  j k j l     �� l m��   l J D--------------------------------------------------------------------    m � n n � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - k  o p o l     �� q r��   q   Find and Replace Suite    r � s s .   F i n d   a n d   R e p l a c e   S u i t e p  t u t l     ��������  ��  ��   u  v w v l     �� x y��   x   find pattern    y � z z    f i n d   p a t t e r n w  { | { l     ��������  ��  ��   |  } ~ } i   "  �  I      �� ����� $0 _matchinforecord _matchInfoRecord �  � � � o      ���� 0 
asocstring 
asocString �  � � � o      ����  0 asocmatchrange asocMatchRange �  � � � o      ���� 0 
textoffset 
textOffset �  ��� � o      ���� 0 
recordtype 
recordType��  ��   � k     # � �  � � � r     
 � � � c      � � � l     ����� � n     � � � I    �� ����� *0 substringwithrange_ substringWithRange_ �  ��� � o    ����  0 asocmatchrange asocMatchRange��  ��   � o     ���� 0 
asocstring 
asocString��  ��   � m    ��
�� 
ctxt � o      ���� 0 	foundtext 	foundText �  � � � l    � � � � r     � � � [     � � � o    ���� 0 
textoffset 
textOffset � l    ����� � n     � � � 1    ��
�� 
leng � o    ���� 0 	foundtext 	foundText��  ��   � o      ����  0 nexttextoffset nextTextOffset � : 4 calculate the start index of the next AS text range    � � � � h   c a l c u l a t e   t h e   s t a r t   i n d e x   o f   t h e   n e x t   A S   t e x t   r a n g e �  � � � l   �� � ���   �
 note: record keys are identifiers, not keywords, as 1. library-defined keywords are a huge pain to use outside of `tell script...` blocks and 2. importing the library's terminology into the global namespace via `use script...` is an excellent way to create keyword conflicts; only the class value is a keyword since Script Editor/OSAKit don't correctly handle records that use non-typename values (e.g. `{class:"matched text",...}`), but this shouldn't impact usability as it's really only used for informational purposes    � � � �   n o t e :   r e c o r d   k e y s   a r e   i d e n t i f i e r s ,   n o t   k e y w o r d s ,   a s   1 .   l i b r a r y - d e f i n e d   k e y w o r d s   a r e   a   h u g e   p a i n   t o   u s e   o u t s i d e   o f   ` t e l l   s c r i p t . . . `   b l o c k s   a n d   2 .   i m p o r t i n g   t h e   l i b r a r y ' s   t e r m i n o l o g y   i n t o   t h e   g l o b a l   n a m e s p a c e   v i a   ` u s e   s c r i p t . . . `   i s   a n   e x c e l l e n t   w a y   t o   c r e a t e   k e y w o r d   c o n f l i c t s ;   o n l y   t h e   c l a s s   v a l u e   i s   a   k e y w o r d   s i n c e   S c r i p t   E d i t o r / O S A K i t   d o n ' t   c o r r e c t l y   h a n d l e   r e c o r d s   t h a t   u s e   n o n - t y p e n a m e   v a l u e s   ( e . g .   ` { c l a s s : " m a t c h e d   t e x t " , . . . } ` ) ,   b u t   t h i s   s h o u l d n ' t   i m p a c t   u s a b i l i t y   a s   i t ' s   r e a l l y   o n l y   u s e d   f o r   i n f o r m a t i o n a l   p u r p o s e s �  ��� � L    # � � J    " � �  � � � K     � � �� � �
�� 
pcls � o    ���� 0 
recordtype 
recordType � �� � ��� 0 
startindex 
startIndex � o    ���� 0 
textoffset 
textOffset � �� � ��� 0 endindex endIndex � \     � � � o    ����  0 nexttextoffset nextTextOffset � m    ����  � �� ����� 0 	foundtext 	foundText � o    ���� 0 	foundtext 	foundText��   �  ��� � o     ����  0 nexttextoffset nextTextOffset��  ��   ~  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i  # & � � � I      �� ����� 0 _matchrecords _matchRecords �  � � � o      ���� 0 
asocstring 
asocString �  � � � o      ����  0 asocmatchrange asocMatchRange �  � � � o      ����  0 asocstartindex asocStartIndex �  � � � o      ���� 0 
textoffset 
textOffset �  � � � o      ���� (0 nonmatchrecordtype nonMatchRecordType �  ��� � o      ���� "0 matchrecordtype matchRecordType��  ��   � k     V � �  � � � l     �� � ���   �TN important: NSString character indexes aren't guaranteed to be same as AS character indexes (AS sensibly counts glyphs but NSString only counts UTF16 codepoints, and a glyph may be composed of more than one codepoint), so reconstruct both non-matching and matching AS text values, and calculate accurate AS character ranges from those    � � � ��   i m p o r t a n t :   N S S t r i n g   c h a r a c t e r   i n d e x e s   a r e n ' t   g u a r a n t e e d   t o   b e   s a m e   a s   A S   c h a r a c t e r   i n d e x e s   ( A S   s e n s i b l y   c o u n t s   g l y p h s   b u t   N S S t r i n g   o n l y   c o u n t s   U T F 1 6   c o d e p o i n t s ,   a n d   a   g l y p h   m a y   b e   c o m p o s e d   o f   m o r e   t h a n   o n e   c o d e p o i n t ) ,   s o   r e c o n s t r u c t   b o t h   n o n - m a t c h i n g   a n d   m a t c h i n g   A S   t e x t   v a l u e s ,   a n d   c a l c u l a t e   a c c u r a t e   A S   c h a r a c t e r   r a n g e s   f r o m   t h o s e �  � � � r      � � � n     � � � I    �������� 0 location  ��  ��   � o     ��  0 asocmatchrange asocMatchRange � o      �~�~  0 asocmatchstart asocMatchStart �  � � � r     � � � [     � � � o    	�}�}  0 asocmatchstart asocMatchStart � l  	  ��|�{ � n  	  � � � I   
 �z�y�x�z 
0 length  �y  �x   � o   	 
�w�w  0 asocmatchrange asocMatchRange�|  �{   � o      �v�v 0 asocmatchend asocMatchEnd �  � � � r     � � � K     � � �u � ��u 0 location   � o    �t�t  0 asocstartindex asocStartIndex � �s ��r�s 
0 length   � \     � � � o    �q�q  0 asocmatchstart asocMatchStart � o    �p�p  0 asocstartindex asocStartIndex�r   � o      �o�o &0 asocnonmatchrange asocNonMatchRange �  � � � r    5 � � � I      �n ��m�n $0 _matchinforecord _matchInfoRecord �  � � � o    �l�l 0 
asocstring 
asocString �  � � � o     �k�k &0 asocnonmatchrange asocNonMatchRange �  � � � o     !�j�j 0 
textoffset 
textOffset �  ��i � o   ! "�h�h (0 nonmatchrecordtype nonMatchRecordType�i  �m   � J       � �  � � � o      �g�g 0 nonmatchinfo nonMatchInfo �  ��f � o      �e�e 0 
textoffset 
textOffset�f   �  � � � r   6 N � � � I      �d ��c�d $0 _matchinforecord _matchInfoRecord �  �  � o   7 8�b�b 0 
asocstring 
asocString   o   8 9�a�a  0 asocmatchrange asocMatchRange  o   9 :�`�` 0 
textoffset 
textOffset �_ o   : ;�^�^ "0 matchrecordtype matchRecordType�_  �c   � J        o      �]�] 0 	matchinfo 	matchInfo 	�\	 o      �[�[ 0 
textoffset 
textOffset�\   � 
�Z
 L   O V J   O U  o   O P�Y�Y 0 nonmatchinfo nonMatchInfo  o   P Q�X�X 0 	matchinfo 	matchInfo  o   Q R�W�W 0 asocmatchend asocMatchEnd �V o   R S�U�U 0 
textoffset 
textOffset�V  �Z   �  l     �T�S�R�T  �S  �R    l     �Q�P�O�Q  �P  �O    i  ' * I      �N�M�N &0 _matchedgrouplist _matchedGroupList  o      �L�L 0 
asocstring 
asocString   o      �K�K 0 	asocmatch 	asocMatch  !"! o      �J�J 0 
textoffset 
textOffset" #�I# o      �H�H &0 includenonmatches includeNonMatches�I  �M   k     �$$ %&% r     '(' J     �G�G  ( o      �F�F "0 submatchresults subMatchResults& )*) r    +,+ \    -.- l   
/�E�D/ n   
010 I    
�C�B�A�C  0 numberofranges numberOfRanges�B  �A  1 o    �@�@ 0 	asocmatch 	asocMatch�E  �D  . m   
 �?�? , o      �>�> 0 groupindexes groupIndexes* 232 Z    �45�=�<4 ?    676 o    �;�; 0 groupindexes groupIndexes7 m    �:�:  5 k    �88 9:9 r    ;<; n   =>= I    �9?�8�9 0 rangeatindex_ rangeAtIndex_? @�7@ m    �6�6  �7  �8  > o    �5�5 0 	asocmatch 	asocMatch< o      �4�4 (0 asocfullmatchrange asocFullMatchRange: ABA r    %CDC n   #EFE I    #�3�2�1�3 0 location  �2  �1  F o    �0�0 (0 asocfullmatchrange asocFullMatchRangeD o      �/�/ &0 asocnonmatchstart asocNonMatchStartB GHG r   & /IJI [   & -KLK o   & '�.�. &0 asocnonmatchstart asocNonMatchStartL l  ' ,M�-�,M n  ' ,NON I   ( ,�+�*�)�+ 
0 length  �*  �)  O o   ' (�(�( (0 asocfullmatchrange asocFullMatchRange�-  �,  J o      �'�' $0 asocfullmatchend asocFullMatchEndH PQP Y   0 �R�&ST�%R k   : �UU VWV r   : oXYX I      �$Z�#�$ 0 _matchrecords _matchRecordsZ [\[ o   ; <�"�" 0 
asocstring 
asocString\ ]^] n  < B_`_ I   = B�!a� �! 0 rangeatindex_ rangeAtIndex_a b�b o   = >�� 0 i  �  �   ` o   < =�� 0 	asocmatch 	asocMatch^ cdc o   B C�� &0 asocnonmatchstart asocNonMatchStartd efe o   C D�� 0 
textoffset 
textOffsetf ghg o   D I�� (0 _unmatchedtexttype _UnmatchedTextTypeh i�i o   I N�� &0 _matchedgrouptype _MatchedGroupType�  �#  Y J      jj klk o      �� 0 nonmatchinfo nonMatchInfol mnm o      �� 0 	matchinfo 	matchInfon opo o      �� &0 asocnonmatchstart asocNonMatchStartp q�q o      �� 0 
textoffset 
textOffset�  W rsr Z  p |tu��t o   p q�� &0 includenonmatches includeNonMatchesu r   t xvwv o   t u�� 0 nonmatchinfo nonMatchInfow n      xyx  ;   v wy o   u v�� "0 submatchresults subMatchResults�  �  s z�z r   } �{|{ o   } ~�� 0 	matchinfo 	matchInfo| n      }~}  ;    �~ o   ~ �� "0 submatchresults subMatchResults�  �& 0 i  S m   3 4�
�
 T o   4 5�	�	 0 groupindexes groupIndexes�%  Q � Z   � ������ o   � ��� &0 includenonmatches includeNonMatches� k   � ��� ��� r   � ���� K   � ��� ���� 0 location  � o   � ��� &0 asocnonmatchstart asocNonMatchStart� ���� 
0 length  � \   � ���� o   � �� �  $0 asocfullmatchend asocFullMatchEnd� o   � ����� &0 asocnonmatchstart asocNonMatchStart�  � o      ���� &0 asocnonmatchrange asocNonMatchRange� ���� r   � ���� n   � ���� 4   � ����
�� 
cobj� m   � ����� � I   � �������� $0 _matchinforecord _matchInfoRecord� ��� o   � ����� 0 
asocstring 
asocString� ��� o   � ����� &0 asocnonmatchrange asocNonMatchRange� ��� o   � ����� 0 
textoffset 
textOffset� ���� o   � ����� (0 _unmatchedtexttype _UnmatchedTextType��  ��  � n      ���  ;   � �� o   � ����� "0 submatchresults subMatchResults��  �  �  �  �=  �<  3 ���� L   � ��� o   � ����� "0 submatchresults subMatchResults��   ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  + .��� I      ������� 0 _findpattern _findPattern� ��� o      ���� 0 thetext theText� ��� o      ���� 0 patterntext patternText� ��� o      ���� &0 includenonmatches includeNonMatches� ���� o      ����  0 includematches includeMatches��  ��  � k    �� ��� r     ��� n    ��� I    ������� (0 asbooleanparameter asBooleanParameter� ��� o    ���� &0 includenonmatches includeNonMatches� ���� m    �� ���  u n m a t c h e d   t e x t��  ��  � o     ���� 0 _support  � o      ���� &0 includenonmatches includeNonMatches� ��� r    ��� n   ��� I    ������� (0 asbooleanparameter asBooleanParameter� ��� o    ����  0 includematches includeMatches� ���� m    �� ���  m a t c h e d   t e x t��  ��  � o    ���� 0 _support  � o      ����  0 includematches includeMatches� ��� r    *��� n   (��� I   ! (������� @0 asnsregularexpressionparameter asNSRegularExpressionParameter� ��� o   ! "���� 0 patterntext patternText� ��� m   " #����  � ���� m   # $�� ���  f o r��  ��  � o    !���� 0 _support  � o      ���� 0 asocpattern asocPattern� ��� r   + 7��� n  + 5��� I   0 5������� ,0 asnormalizednsstring asNormalizedNSString� ���� o   0 1���� 0 thetext theText��  ��  � o   + 0���� 0 _support  � o      ���� 0 
asocstring 
asocString� ��� l  8 ;���� r   8 ;��� m   8 9����  � o      ���� &0 asocnonmatchstart asocNonMatchStart� G A used to calculate NSRanges for non-matching portions of NSString   � ��� �   u s e d   t o   c a l c u l a t e   N S R a n g e s   f o r   n o n - m a t c h i n g   p o r t i o n s   o f   N S S t r i n g� ��� l  < ?���� r   < ?��� m   < =���� � o      ���� 0 
textoffset 
textOffset� B < used to calculate correct AppleScript start and end indexes   � ��� x   u s e d   t o   c a l c u l a t e   c o r r e c t   A p p l e S c r i p t   s t a r t   a n d   e n d   i n d e x e s� ��� r   @ D��� J   @ B����  � o      ���� 0 
resultlist 
resultList� ��� l  E E������  � @ : iterate over each non-matched + matched range in NSString   � ��� t   i t e r a t e   o v e r   e a c h   n o n - m a t c h e d   +   m a t c h e d   r a n g e   i n   N S S t r i n g� ��� r   E V��� n  E T��� I   F T������� @0 matchesinstring_options_range_ matchesInString_options_range_�    o   F G���� 0 
asocstring 
asocString  m   G H����   �� J   H P  m   H I����   �� n  I N	
	 I   J N�������� 
0 length  ��  ��  
 o   I J���� 0 
asocstring 
asocString��  ��  ��  � o   E F���� 0 asocpattern asocPattern� o      ����  0 asocmatcharray asocMatchArray�  Y   W ����� k   g �  r   g o l  g m���� n  g m I   h m������  0 objectatindex_ objectAtIndex_ �� o   h i���� 0 i  ��  ��   o   g h����  0 asocmatcharray asocMatchArray��  ��   o      ���� 0 	asocmatch 	asocMatch  l  p p����   � � the first range in match identifies the text matched by the entire pattern, so generate records for full match and its preceding (unmatched) text    �$   t h e   f i r s t   r a n g e   i n   m a t c h   i d e n t i f i e s   t h e   t e x t   m a t c h e d   b y   t h e   e n t i r e   p a t t e r n ,   s o   g e n e r a t e   r e c o r d s   f o r   f u l l   m a t c h   a n d   i t s   p r e c e d i n g   ( u n m a t c h e d )   t e x t   r   p �!"! I      ��#���� 0 _matchrecords _matchRecords# $%$ o   q r���� 0 
asocstring 
asocString% &'& n  r x()( I   s x��*���� 0 rangeatindex_ rangeAtIndex_* +��+ m   s t����  ��  ��  ) o   r s���� 0 	asocmatch 	asocMatch' ,-, o   x y���� &0 asocnonmatchstart asocNonMatchStart- ./. o   y z���� 0 
textoffset 
textOffset/ 010 o   z ���� (0 _unmatchedtexttype _UnmatchedTextType1 2��2 o    ����� $0 _matchedtexttype _MatchedTextType��  ��  " J      33 454 o      ���� 0 nonmatchinfo nonMatchInfo5 676 o      ���� 0 	matchinfo 	matchInfo7 898 o      ���� &0 asocnonmatchstart asocNonMatchStart9 :��: o      ���� 0 
textoffset 
textOffset��    ;<; Z  � �=>����= o   � ����� &0 includenonmatches includeNonMatches> r   � �?@? o   � ����� 0 nonmatchinfo nonMatchInfo@ n      ABA  ;   � �B o   � ����� 0 
resultlist 
resultList��  ��  < C��C Z   � �DE����D o   � �����  0 includematches includeMatchesE k   � �FF GHG l  � ���IJ��  I any additional ranges in match identify text matched by group references within regexp pattern, e.g. "([0-9]{4})-([0-9]{2})-([0-9]{2})" will match `YYYY-MM-DD` style date strings, returning the entire text match, plus sub-matches representing year, month and day text   J �KK   a n y   a d d i t i o n a l   r a n g e s   i n   m a t c h   i d e n t i f y   t e x t   m a t c h e d   b y   g r o u p   r e f e r e n c e s   w i t h i n   r e g e x p   p a t t e r n ,   e . g .   " ( [ 0 - 9 ] { 4 } ) - ( [ 0 - 9 ] { 2 } ) - ( [ 0 - 9 ] { 2 } ) "   w i l l   m a t c h   ` Y Y Y Y - M M - D D `   s t y l e   d a t e   s t r i n g s ,   r e t u r n i n g   t h e   e n t i r e   t e x t   m a t c h ,   p l u s   s u b - m a t c h e s   r e p r e s e n t i n g   y e a r ,   m o n t h   a n d   d a y   t e x tH L��L r   � �MNM b   � �OPO o   � ����� 0 	matchinfo 	matchInfoP K   � �QQ ��R���� 0 foundgroups foundGroupsR I   � ���S���� &0 _matchedgrouplist _matchedGroupListS TUT o   � ����� 0 
asocstring 
asocStringU VWV o   � ����� 0 	asocmatch 	asocMatchW XYX n  � �Z[Z o   � ����� 0 
startindex 
startIndex[ o   � ����� 0 	matchinfo 	matchInfoY \��\ o   � ����� &0 includenonmatches includeNonMatches��  ��  ��  N n      ]^]  ;   � �^ o   � ����� 0 
resultlist 
resultList��  ��  ��  ��  �� 0 i   m   Z [��   \   [ b_`_ l  [ `a�~�}a n  [ `bcb I   \ `�|�{�z�| 	0 count  �{  �z  c o   [ \�y�y  0 asocmatcharray asocMatchArray�~  �}  ` m   ` a�x�x ��   ded l  � ��wfg�w  f "  add final non-matched range   g �hh 8   a d d   f i n a l   n o n - m a t c h e d   r a n g ee iji Z   �
kl�v�uk o   � ��t�t &0 includenonmatches includeNonMatchesl k   �mm non r   � �pqp c   � �rsr l  � �t�s�rt n  � �uvu I   � ��qw�p�q *0 substringfromindex_ substringFromIndex_w x�ox o   � ��n�n &0 asocnonmatchstart asocNonMatchStart�o  �p  v o   � ��m�m 0 
asocstring 
asocString�s  �r  s m   � ��l
�l 
ctxtq o      �k�k 0 	foundtext 	foundTexto y�jy r   �z{z K   �|| �i}~
�i 
pcls} o   � ��h�h (0 _unmatchedtexttype _UnmatchedTextType~ �g��g 0 
startindex 
startIndex o   � ��f�f 0 
textoffset 
textOffset� �e���e 0 endindex endIndex� n   � ���� 1   � ��d
�d 
leng� o   � ��c�c 0 thetext theText� �b��a�b 0 	foundtext 	foundText� o   � ��`�` 0 	foundtext 	foundText�a  { n      ���  ;  � o  �_�_ 0 
resultlist 
resultList�j  �v  �u  j ��^� L  �� o  �]�] 0 
resultlist 
resultList�^  � ��� l     �\�[�Z�\  �[  �Z  � ��� l     �Y�X�W�Y  �X  �W  � ��� l     �V���V  �  -----   � ��� 
 - - - - -� ��� l     �U���U  �   replace pattern   � ���     r e p l a c e   p a t t e r n� ��� l     �T�S�R�T  �S  �R  � ��� i  / 2��� I      �Q��P�Q "0 _replacepattern _replacePattern� ��� o      �O�O 0 thetext theText� ��� o      �N�N 0 patterntext patternText� ��M� o      �L�L 0 templatetext templateText�M  �P  � k    L�� ��� r     ��� n    
��� I    
�K��J�K ,0 asnormalizednsstring asNormalizedNSString� ��I� o    �H�H 0 thetext theText�I  �J  � o     �G�G 0 _support  � o      �F�F 0 
asocstring 
asocString� ��� r    ��� n   ��� I    �E��D�E @0 asnsregularexpressionparameter asNSRegularExpressionParameter� ��� o    �C�C 0 patterntext patternText� ��� m    �B�B  � ��A� m    �� ���  f o r�A  �D  � o    �@�@ 0 _support  � o      �?�? 0 asocpattern asocPattern� ��>� Z   L���=�� >    '��� l   %��<�;� I   %�:��
�: .corecnte****       ****� J    �� ��9� o    �8�8 0 templatetext templateText�9  � �7��6
�7 
kocl� m     !�5
�5 
scpt�6  �<  �;  � m   % &�4�4  � k   *8�� ��� r   * F��� J   * 0�� ��� J   * ,�3�3  � ��� m   , -�2�2  � ��1� m   - .�0�0 �1  � J      �� ��� o      �/�/ 0 
resultlist 
resultList� ��� o      �.�. &0 asocnonmatchstart asocNonMatchStart� ��-� o      �,�, 0 
textoffset 
textOffset�-  � ��� r   G X��� n  G V��� I   H V�+��*�+ @0 matchesinstring_options_range_ matchesInString_options_range_� ��� o   H I�)�) 0 
asocstring 
asocString� ��� m   I J�(�(  � ��'� J   J R�� ��� m   J K�&�&  � ��%� n  K P��� I   L P�$�#�"�$ 
0 length  �#  �"  � o   K L�!�! 0 
asocstring 
asocString�%  �'  �*  � o   G H� �  0 asocpattern asocPattern� o      ��  0 asocmatcharray asocMatchArray� ��� Y   Y ������� k   i ��� ��� r   i q��� l  i o���� n  i o��� I   j o����  0 objectatindex_ objectAtIndex_� ��� o   j k�� 0 i  �  �  � o   i j��  0 asocmatcharray asocMatchArray�  �  � o      �� 0 	asocmatch 	asocMatch� ��� r   r ���� I      ���� 0 _matchrecords _matchRecords� ��� o   s t�� 0 
asocstring 
asocString�    n  t z I   u z��� 0 rangeatindex_ rangeAtIndex_ � m   u v��  �  �   o   t u�� 0 	asocmatch 	asocMatch  o   z {�� &0 asocnonmatchstart asocNonMatchStart 	 o   { |�� 0 
textoffset 
textOffset	 

 o   | ��
�
 (0 _unmatchedtexttype _UnmatchedTextType �	 o   � ��� $0 _matchedtexttype _MatchedTextType�	  �  � J        o      �� 0 nonmatchinfo nonMatchInfo  o      �� 0 	matchinfo 	matchInfo  o      �� &0 asocnonmatchstart asocNonMatchStart � o      �� 0 
textoffset 
textOffset�  �  r   � � n  � � o   � ��� 0 	foundtext 	foundText o   � ��� 0 nonmatchinfo nonMatchInfo n        ;   � � o   � �� �  0 
resultlist 
resultList  r   � �  I   � ���!���� &0 _matchedgrouplist _matchedGroupList! "#" o   � ����� 0 
asocstring 
asocString# $%$ o   � ����� 0 	asocmatch 	asocMatch% &'& n  � �()( o   � ����� 0 
startindex 
startIndex) o   � ����� 0 	matchinfo 	matchInfo' *��* m   � ���
�� boovtrue��  ��    o      ���� 0 matchedgroups matchedGroups +��+ Q   � �,-., r   � �/0/ c   � �121 n  � �343 I   � ���5����  0 replacepattern replacePattern5 676 n  � �898 o   � ����� 0 	foundtext 	foundText9 o   � ����� 0 	matchinfo 	matchInfo7 :��: o   � ����� 0 matchedgroups matchedGroups��  ��  4 o   � ����� 0 templatetext templateText2 m   � ���
�� 
ctxt0 n      ;<;  ;   � �< o   � ����� 0 
resultlist 
resultList- R      ��=>
�� .ascrerr ****      � ****= o      ���� 0 etext eText> ��?@
�� 
errn? o      ���� 0 enumber eNumber@ ��AB
�� 
erobA o      ���� 0 efrom eFromB ��C��
�� 
errtC o      ���� 
0 eto eTo��  . R   � ���DE
�� .ascrerr ****      � ****D b   � �FGF m   � �HH �II � A n   e r r o r   o c c u r r e d   w h e n   c a l l i n g   t h e    r e p l a c e   p a t t e r n    s c r i p t   o b j e c t :  G o   � ����� 0 etext eTextE ��JK
�� 
errnJ o   � ����� 0 enumber eNumberK ��LM
�� 
erobL o   � ����� 0 efrom eFromM ��N��
�� 
errtN o   � ����� 
0 eto eTo��  ��  � 0 i  � m   \ ]����  � \   ] dOPO l  ] bQ����Q n  ] bRSR I   ^ b�������� 	0 count  ��  ��  S o   ] ^����  0 asocmatcharray asocMatchArray��  ��  P m   b c���� �  � TUT l  � ���VW��  V "  add final non-matched range   W �XX 8   a d d   f i n a l   n o n - m a t c h e d   r a n g eU YZY r   �[\[ c   �]^] l  � �_����_ n  � �`a` I   � ���b���� *0 substringfromindex_ substringFromIndex_b c��c o   � ����� &0 asocnonmatchstart asocNonMatchStart��  ��  a o   � ����� 0 
asocstring 
asocString��  ��  ^ m   ���
�� 
ctxt\ n      ded  ;  e o  ���� 0 
resultlist 
resultListZ fgf r  hih n jkj 1  	��
�� 
txdlk 1  	��
�� 
ascri o      ���� 0 oldtids oldTIDsg lml r  non m  pp �qq  o n     rsr 1  ��
�� 
txdls 1  ��
�� 
ascrm tut r  'vwv c  #xyx o  ���� 0 
resultlist 
resultListy m  "��
�� 
ctxtw o      ���� 0 
resulttext 
resultTextu z{z r  (3|}| o  (+���� 0 oldtids oldTIDs} n     ~~ 1  .2��
�� 
txdl 1  +.��
�� 
ascr{ ���� L  48�� o  47���� 0 
resulttext 
resultText��  �=  � L  ;L�� n ;K��� I  <K������� |0 <stringbyreplacingmatchesinstring_options_range_withtemplate_ <stringByReplacingMatchesInString_options_range_withTemplate_� ��� l 
<=������ o  <=���� 0 
asocstring 
asocString��  ��  � ��� m  =>����  � ��� J  >F�� ��� m  >?����  � ���� n ?D��� I  @D�������� 
0 length  ��  ��  � o  ?@���� 0 
asocstring 
asocString��  � ���� o  FG���� 0 templatetext templateText��  ��  � o  ;<���� 0 asocpattern asocPattern�>  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  �  -----   � ��� 
 - - - - -� ��� l     ������  �  
 find text   � ���    f i n d   t e x t� ��� l     ��������  ��  ��  � ��� i  3 6��� I      ������� 0 	_findtext 	_findText� ��� o      ���� 0 thetext theText� ��� o      ���� 0 fortext forText� ��� o      ���� &0 includenonmatches includeNonMatches� ���� o      ����  0 includematches includeMatches��  ��  � k    (�� ��� l    ���� Z    ������� =    ��� o     ���� 0 fortext forText� m    �� ���  � R    ����
�� .ascrerr ****      � ****� m    �� ��� � I n v a l i d    f o r    p a r a m e t e r   ( t e x t   i s   e m p t y ,   o r   o n l y   c o n t a i n s   c h a r a c t e r s   i g n o r e d   b y   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s )� ����
�� 
errn� m    	�����Y� �����
�� 
erob� o   
 ���� 0 fortext forText��  ��  ��  ��� checks if all characters in forText are ignored by current considering/ignoring settings (the alternative would be to return each character as a non-match separated by a zero-length match, but that's probably not what the user intended); note that unlike `aString's length = 0`, which is what library code normally uses to check for empty text, on this occasion we do want to take into account the current considering/ignoring settings so deliberately use `forText is ""` here. For example, when ignoring punctuation, searching for the TID `"!?"` is no different to searching for `""`, because all of its characters are being ignored when comparing the text being searched against the text being searched for. Thus, a simple `forText is ""` test can be used to check in advance if the text contains any matchable characters under the current considering/ignoring settings, and report a meaningful error if not.   � ���   c h e c k s   i f   a l l   c h a r a c t e r s   i n   f o r T e x t   a r e   i g n o r e d   b y   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s   ( t h e   a l t e r n a t i v e   w o u l d   b e   t o   r e t u r n   e a c h   c h a r a c t e r   a s   a   n o n - m a t c h   s e p a r a t e d   b y   a   z e r o - l e n g t h   m a t c h ,   b u t   t h a t ' s   p r o b a b l y   n o t   w h a t   t h e   u s e r   i n t e n d e d ) ;   n o t e   t h a t   u n l i k e   ` a S t r i n g ' s   l e n g t h   =   0 ` ,   w h i c h   i s   w h a t   l i b r a r y   c o d e   n o r m a l l y   u s e s   t o   c h e c k   f o r   e m p t y   t e x t ,   o n   t h i s   o c c a s i o n   w e   d o   w a n t   t o   t a k e   i n t o   a c c o u n t   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s   s o   d e l i b e r a t e l y   u s e   ` f o r T e x t   i s   " " `   h e r e .   F o r   e x a m p l e ,   w h e n   i g n o r i n g   p u n c t u a t i o n ,   s e a r c h i n g   f o r   t h e   T I D   ` " ! ? " `   i s   n o   d i f f e r e n t   t o   s e a r c h i n g   f o r   ` " " ` ,   b e c a u s e   a l l   o f   i t s   c h a r a c t e r s   a r e   b e i n g   i g n o r e d   w h e n   c o m p a r i n g   t h e   t e x t   b e i n g   s e a r c h e d   a g a i n s t   t h e   t e x t   b e i n g   s e a r c h e d   f o r .   T h u s ,   a   s i m p l e   ` f o r T e x t   i s   " " `   t e s t   c a n   b e   u s e d   t o   c h e c k   i n   a d v a n c e   i f   t h e   t e x t   c o n t a i n s   a n y   m a t c h a b l e   c h a r a c t e r s   u n d e r   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s ,   a n d   r e p o r t   a   m e a n i n g f u l   e r r o r   i f   n o t .� ��� r    ��� J    ����  � o      ���� 0 
resultlist 
resultList� ��� r    ��� n   ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� o      ���� 0 oldtids oldTIDs� ��� r    #��� o    ���� 0 fortext forText� n     ��� 1     "��
�� 
txdl� 1     ��
�� 
ascr� ��� r   $ '��� m   $ %���� � o      ���� 0 
startindex 
startIndex� ��� r   ( 0��� n   ( .��� 1   , .��
�� 
leng� n   ( ,��� 4   ) ,���
�� 
citm� m   * +���� � o   ( )���� 0 thetext theText� o      ���� 0 endindex endIndex� ��� Z   1 f������� o   1 2���� &0 includenonmatches includeNonMatches� k   5 b�� ��� Z   5 N����� B   5 8��� o   5 6�~�~ 0 
startindex 
startIndex� o   6 7�}�} 0 endindex endIndex� r   ; H��� n   ; F��� 7  < F�|��
�| 
ctxt� o   @ B�{�{ 0 
startindex 
startIndex� o   C E�z�z 0 endindex endIndex� o   ; <�y�y 0 thetext theText� o      �x�x 0 	foundtext 	foundText�  � r   K N��� m   K L�� ���  � o      �w�w 0 	foundtext 	foundText� ��v� r   O b��� K   O _�� �u��
�u 
pcls� o   P U�t�t (0 _unmatchedtexttype _UnmatchedTextType� �s���s 0 
startindex 
startIndex� o   V W�r�r 0 
startindex 
startIndex� �q� �q 0 endindex endIndex� o   X Y�p�p 0 endindex endIndex  �o�n�o 0 	foundtext 	foundText o   Z [�m�m 0 	foundtext 	foundText�n  � n        ;   ` a o   _ `�l�l 0 
resultlist 
resultList�v  ��  ��  �  Y   g�k�j k   w		 

 r   w | [   w z o   w x�i�i 0 endindex endIndex m   x y�h�h  o      �g�g 0 
startindex 
startIndex  r   } � \   } � l  } ��f�e n   } � 1   ~ ��d
�d 
leng o   } ~�c�c 0 thetext theText�f  �e   l  � ��b�a n   � � 1   � ��`
�` 
leng n   � � 7  � ��_
�_ 
ctxt l  � � �^�]  4   � ��\!
�\ 
citm! o   � ��[�[ 0 i  �^  �]   l  � �"�Z�Y" 4   � ��X#
�X 
citm# m   � ��W�W���Z  �Y   o   � ��V�V 0 thetext theText�b  �a   o      �U�U 0 endindex endIndex $%$ Z   � �&'�T�S& o   � ��R�R  0 includematches includeMatches' k   � �(( )*) Z   � �+,�Q-+ B   � �./. o   � ��P�P 0 
startindex 
startIndex/ o   � ��O�O 0 endindex endIndex, r   � �010 n   � �232 7  � ��N45
�N 
ctxt4 o   � ��M�M 0 
startindex 
startIndex5 o   � ��L�L 0 endindex endIndex3 o   � ��K�K 0 thetext theText1 o      �J�J 0 	foundtext 	foundText�Q  - r   � �676 m   � �88 �99  7 o      �I�I 0 	foundtext 	foundText* :�H: r   � �;<; K   � �== �G>?
�G 
pcls> o   � ��F�F $0 _matchedtexttype _MatchedTextType? �E@A�E 0 
startindex 
startIndex@ o   � ��D�D 0 
startindex 
startIndexA �CBC�C 0 endindex endIndexB o   � ��B�B 0 endindex endIndexC �ADE�A 0 	foundtext 	foundTextD o   � ��@�@ 0 	foundtext 	foundTextE �?F�>�? 0 foundgroups foundGroupsF J   � ��=�=  �>  < n      GHG  ;   � �H o   � ��<�< 0 
resultlist 
resultList�H  �T  �S  % IJI r   � �KLK [   � �MNM o   � ��;�; 0 endindex endIndexN m   � ��:�: L o      �9�9 0 
startindex 
startIndexJ OPO r   � �QRQ \   � �STS [   � �UVU o   � ��8�8 0 
startindex 
startIndexV l  � �W�7�6W n   � �XYX 1   � ��5
�5 
lengY n   � �Z[Z 4   � ��4\
�4 
citm\ o   � ��3�3 0 i  [ o   � ��2�2 0 thetext theText�7  �6  T m   � ��1�1 R o      �0�0 0 endindex endIndexP ]�/] Z   �^_�.�-^ o   � ��,�, &0 includenonmatches includeNonMatches_ k   �`` aba Z   �cd�+ec B   � �fgf o   � ��*�* 0 
startindex 
startIndexg o   � ��)�) 0 endindex endIndexd r   � �hih n   � �jkj 7  � ��(lm
�( 
ctxtl o   � ��'�' 0 
startindex 
startIndexm o   � ��&�& 0 endindex endIndexk o   � ��%�% 0 thetext theTexti o      �$�$ 0 	foundtext 	foundText�+  e r   �non m   � pp �qq  o o      �#�# 0 	foundtext 	foundTextb r�"r r  sts K  uu �!vw
�! 
pclsv o  	� �  (0 _unmatchedtexttype _UnmatchedTextTypew �xy� 0 
startindex 
startIndexx o  
�� 0 
startindex 
startIndexy �z{� 0 endindex endIndexz o  �� 0 endindex endIndex{ �|�� 0 	foundtext 	foundText| o  �� 0 	foundtext 	foundText�  t n      }~}  ;  ~ o  �� 0 
resultlist 
resultList�"  �.  �-  �/  �k 0 i   m   j k��  I  k r��
� .corecnte****       **** n   k n��� 2  l n�
� 
citm� o   k l�� 0 thetext theText�  �j   ��� r   %��� o   !�� 0 oldtids oldTIDs� n     ��� 1  "$�
� 
txdl� 1  !"�
� 
ascr� ��� L  &(�� o  &'�� 0 
resultlist 
resultList�  � ��� l     ����  �  �  � ��� l     �
�	��
  �	  �  � ��� l     ����  �  -----   � ��� 
 - - - - -� ��� l     ����  �   replace text   � ���    r e p l a c e   t e x t� ��� l     ����  �  �  � ��� i  7 :��� I      ���� 0 _replacetext _replaceText� ��� o      � �  0 thetext theText� ��� o      ���� 0 fortext forText� ���� o      ���� 0 newtext newText��  �  � k    <�� ��� Z    ������� =    ��� o     ���� 0 fortext forText� m    �� ���  � R    ����
�� .ascrerr ****      � ****� m    �� ��� � I n v a l i d    f o r    p a r a m e t e r   ( t e x t   i s   e m p t y ,   o r   o n l y   c o n t a i n s   c h a r a c t e r s   i g n o r e d   b y   t h e   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s )� ����
�� 
errn� m    	�����Y� �����
�� 
erob� o   
 ���� 0 fortext forText��  ��  ��  � ��� r    ��� n   ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� o      ���� 0 oldtids oldTIDs� ��� r    ��� o    ���� 0 fortext forText� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� ��� Z   -������ >    *��� l   (������ I   (����
�� .corecnte****       ****� J    "�� ���� o     ���� 0 newtext newText��  � �����
�� 
kocl� m   # $��
�� 
scpt��  ��  ��  � m   ( )����  � k   -�� ��� r   - N��� J   - 8�� ��� J   - /����  � ��� m   / 0���� � ���� n   0 6��� 1   4 6��
�� 
leng� n   0 4��� 4   1 4���
�� 
citm� m   2 3���� � o   0 1���� 0 thetext theText��  � J      �� ��� o      ���� 0 
resultlist 
resultList� ��� o      ���� 0 
startindex 
startIndex� ���� o      ���� 0 endindex endIndex��  � ��� Z  O g������� B   O R��� o   O P���� 0 
startindex 
startIndex� o   P Q���� 0 endindex endIndex� r   U c��� n   U `��� 7  V `����
�� 
ctxt� o   Z \���� 0 
startindex 
startIndex� o   ] _���� 0 endindex endIndex� o   U V���� 0 thetext theText� n      ���  ;   a b� o   ` a���� 0 
resultlist 
resultList��  ��  � ��� Y   h�������� k   x�� ��� r   x }��� [   x {��� o   x y���� 0 endindex endIndex� m   y z���� � o      ���� 0 
startindex 
startIndex� ��� r   ~ �� � \   ~ � l  ~ ����� n   ~ � 1    ���
�� 
leng o   ~ ���� 0 thetext theText��  ��   l  � ����� n   � � 1   � ���
�� 
leng n   � �	
	 7  � ���
�� 
ctxt l  � ����� 4   � ���
�� 
citm o   � ����� 0 i  ��  ��   l  � ����� 4   � ���
�� 
citm m   � ���������  ��  
 o   � ����� 0 thetext theText��  ��    o      ���� 0 endindex endIndex�  Z   � ��� B   � � o   � ����� 0 
startindex 
startIndex o   � ����� 0 endindex endIndex r   � � n   � � 7  � ���
�� 
ctxt o   � ����� 0 
startindex 
startIndex o   � ����� 0 endindex endIndex o   � ����� 0 thetext theText o      ���� 0 	foundtext 	foundText��   r   � � m   � �   �!!   o      ���� 0 	foundtext 	foundText "#" Q   � �$%&$ r   � �'(' c   � �)*) n  � �+,+ I   � ���-���� 0 replacetext replaceText- .��. o   � ����� 0 	foundtext 	foundText��  ��  , o   � ����� 0 newtext newText* m   � ���
�� 
ctxt( n      /0/  ;   � �0 o   � ����� 0 
resultlist 
resultList% R      ��12
�� .ascrerr ****      � ****1 o      ���� 0 etext eText2 ��34
�� 
errn3 o      ���� 0 enumber eNumber4 ��56
�� 
erob5 o      ���� 0 efrom eFrom6 ��7��
�� 
errt7 o      ���� 
0 eto eTo��  & R   � ���89
�� .ascrerr ****      � ****8 b   � �:;: m   � �<< �== � A n   e r r o r   o c c u r r e d   w h e n   c a l l i n g   t h e    r e p l a c e   t e x t    s c r i p t   o b j e c t :  ; o   � ����� 0 etext eText9 ��>?
�� 
errn> o   � ����� 0 enumber eNumber? ��@A
�� 
erob@ o   � ����� 0 efrom eFromA ��B��
�� 
errtB o   � ����� 
0 eto eTo��  # CDC r   � �EFE [   � �GHG o   � ����� 0 endindex endIndexH m   � ����� F o      ���� 0 
startindex 
startIndexD IJI r   � �KLK \   � �MNM [   � �OPO o   � ����� 0 
startindex 
startIndexP l  � �Q����Q n   � �RSR 1   � ���
�� 
lengS n   � �TUT 4   � ���V
�� 
citmV o   � ����� 0 i  U o   � ����� 0 thetext theText��  ��  N m   � ����� L o      ���� 0 endindex endIndexJ W��W Z  �XY����X B   � �Z[Z o   � ����� 0 
startindex 
startIndex[ o   � ����� 0 endindex endIndexY r   � �\]\ n   � �^_^ 7  � ���`a
�� 
ctxt` o   � ����� 0 
startindex 
startIndexa o   � ����� 0 endindex endIndex_ o   � ����� 0 thetext theText] n      bcb  ;   � �c o   � ����� 0 
resultlist 
resultList��  ��  ��  �� 0 i  � m   k l���� � I  l s�d�~
� .corecnte****       ****d n   l oefe 2  m o�}
�} 
citmf o   l m�|�| 0 thetext theText�~  ��  � g�{g r  hih m  jj �kk  i n     lml 1  �z
�z 
txdlm 1  �y
�y 
ascr�{  ��  � l -nopn k  -qq rsr l �xtu�x  t   replace with text   u �vv $   r e p l a c e   w i t h   t e x ts wxw r  !yzy n {|{ I  �w}�v�w "0 astextparameter asTextParameter} ~~ o  �u�u 0 newtext newText ��t� m  �� ���  r e p l a c i n g   w i t h�t  �v  | o  �s�s 0 _support  z o      �r�r 0 newtext newTextx ��� l "'���� r  "'��� n "%��� 2 #%�q
�q 
citm� o  "#�p�p 0 thetext theText� o      �o�o 0 
resultlist 
resultList� J D note: TID-based matching uses current considering/ignoring settings   � ��� �   n o t e :   T I D - b a s e d   m a t c h i n g   u s e s   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s� ��n� r  (-��� o  ()�m�m 0 newtext newText� n     ��� 1  *,�l
�l 
txdl� 1  )*�k
�k 
ascr�n  o * $ replace with callback-supplied text   p ��� H   r e p l a c e   w i t h   c a l l b a c k - s u p p l i e d   t e x t� ��� r  .3��� c  .1��� o  ./�j�j 0 
resultlist 
resultList� m  /0�i
�i 
ctxt� o      �h�h 0 
resulttext 
resultText� ��� r  49��� o  45�g�g 0 oldtids oldTIDs� n     ��� 1  68�f
�f 
txdl� 1  56�e
�e 
ascr� ��d� L  :<�� o  :;�c�c 0 
resulttext 
resultText�d  � ��� l     �b�a�`�b  �a  �`  � ��� l     �_�^�]�_  �^  �]  � ��� l     �\���\  �  -----   � ��� 
 - - - - -� ��� l     �[�Z�Y�[  �Z  �Y  � ��� i  ; >��� I     �X��
�X .Txt:Srchnull���     ctxt� o      �W�W 0 thetext theText� �V��
�V 
For_� o      �U�U 0 fortext forText� �T��
�T 
Usin� |�S�R��Q��S  �R  � o      �P�P 0 matchformat matchFormat�Q  � l 
    ��O�N� l     ��M�L� m      �K
�K SerECmpI�M  �L  �O  �N  � �J��
�J 
Repl� |�I�H��G��I  �H  � o      �F�F 0 newtext newText�G  � l     ��E�D� m      �C
�C 
msng�E  �D  � �B��A
�B 
Retu� |�@�?��>��@  �?  � o      �=�= 0 resultformat resultFormat�>  � l     ��<�;� m      �:
�: RetEMatT�<  �;  �A  � Q    ����� k   ��� ��� r    ��� n   ��� I    �9��8�9 "0 astextparameter asTextParameter� ��� o    	�7�7 0 thetext theText� ��6� m   	 
�� ���  �6  �8  � o    �5�5 0 _support  � o      �4�4 0 thetext theText� ��� r    ��� n   ��� I    �3��2�3 "0 astextparameter asTextParameter� ��� o    �1�1 0 fortext forText� ��0� m    �� ���  f o r�0  �2  � o    �/�/ 0 _support  � o      �.�. 0 fortext forText� ��� Z   3���-�,� =    $��� n    "��� 1     "�+
�+ 
leng� o     �*�* 0 fortext forText� m   " #�)�)  � R   ' /�(��
�( .ascrerr ****      � ****� m   - .�� ��� t I n v a l i d    f o r    p a r a m e t e r   ( e x p e c t e d   o n e   o r   m o r e   c h a r a c t e r s ) .� �'��
�' 
errn� m   ) *�&�&�Y� �%��$
�% 
erob� o   + ,�#�# 0 fortext forText�$  �-  �,  � ��"� Z   4����!�� =  4 7��� o   4 5� �  0 newtext newText� m   5 6�
� 
msng� l  :,���� k   :,�� ��� Z   : ������ =  : =��� o   : ;�� 0 resultformat resultFormat� m   ; <�
� RetEMatT� r   @ S   J   @ D  m   @ A�
� boovfals � m   A B�
� boovtrue�   J        o      �� &0 includenonmatches includeNonMatches 	�	 o      ��  0 includematches includeMatches�  � 

 =  V Y o   V W�� 0 resultformat resultFormat m   W X�
� RetEUmaT  r   \ o J   \ `  m   \ ]�
� boovtrue � m   ] ^�
� boovfals�   J        o      �� &0 includenonmatches includeNonMatches � o      ��  0 includematches includeMatches�    =  r u o   r s�� 0 resultformat resultFormat m   s t�
� RetEAllT � r   x �  J   x |!! "#" m   x y�
� boovtrue# $�
$ m   y z�	
�	 boovtrue�
    J      %% &'& o      �� &0 includenonmatches includeNonMatches' (�( o      ��  0 includematches includeMatches�  �  � n  � �)*) I   � ��+�� >0 throwinvalidconstantparameter throwInvalidConstantParameter+ ,-, o   � ��� 0 resultformat resultFormat- .�. m   � �// �00  r e t u r n i n g�  �  * o   � ��� 0 _support  � 1� 1 Z   �,23452 =  � �676 o   � ����� 0 matchformat matchFormat7 m   � ���
�� SerECmpI3 P   � �89:8 L   � �;; I   � ���<���� 0 	_findtext 	_findText< =>= o   � ����� 0 thetext theText> ?@? o   � ����� 0 fortext forText@ ABA o   � ����� &0 includenonmatches includeNonMatchesB C��C o   � �����  0 includematches includeMatches��  ��  9 ��D
�� consdiacD ��E
�� conshyphE ��F
�� conspuncF ��G
�� conswhitG ����
�� consnume��  : ����
�� conscase��  4 HIH =  � �JKJ o   � ����� 0 matchformat matchFormatK m   � ���
�� SerECmpPI LML L   � �NN I   � ���O���� 0 _findpattern _findPatternO PQP o   � ����� 0 thetext theTextQ RSR o   � ����� 0 fortext forTextS TUT o   � ����� &0 includenonmatches includeNonMatchesU V��V o   � �����  0 includematches includeMatches��  ��  M WXW =  � �YZY o   � ����� 0 matchformat matchFormatZ m   � ���
�� SerECmpCX [\[ P   � �]^��] L   � �__ I   � ���`���� 0 	_findtext 	_findText` aba o   � ����� 0 thetext theTextb cdc o   � ����� 0 fortext forTextd efe o   � ����� &0 includenonmatches includeNonMatchesf g��g o   � �����  0 includematches includeMatches��  ��  ^ ��h
�� conscaseh ��i
�� consdiaci ��j
�� conshyphj ��k
�� conspunck ��l
�� conswhitl ����
�� consnume��  ��  \ mnm =  � �opo o   � ����� 0 matchformat matchFormatp m   � ���
�� SerECmpEn qrq P   �stus L   �vv I   ���w���� 0 	_findtext 	_findTextw xyx o   � ����� 0 thetext theTexty z{z o   � ����� 0 fortext forText{ |}| o   � ���� &0 includenonmatches includeNonMatches} ~��~ o   ����  0 includematches includeMatches��  ��  t ��
�� conscase ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ����
�� conswhit��  u ����
�� consnume��  r ��� = 
��� o  
���� 0 matchformat matchFormat� m  ��
�� SerECmpD� ���� L  �� I  ������� 0 	_findtext 	_findText� ��� o  ���� 0 thetext theText� ��� o  ���� 0 fortext forText� ��� o  ���� &0 includenonmatches includeNonMatches� ���� o  ����  0 includematches includeMatches��  ��  ��  5 n ,��� I  $,������� >0 throwinvalidconstantparameter throwInvalidConstantParameter� ��� o  $%���� 0 matchformat matchFormat� ���� m  %(�� ��� 
 u s i n g��  ��  � o  $���� 0 _support  �   �   find matches   � ���    f i n d   m a t c h e s�!  � l /����� Z  /������ = /4��� o  /0���� 0 matchformat matchFormat� m  03��
�� SerECmpI� P  7J���� L  @I�� I  @H������� 0 _replacetext _replaceText� ��� o  AB���� 0 thetext theText� ��� o  BC���� 0 fortext forText� ���� o  CD���� 0 newtext newText��  ��  � ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ���
�� conswhit� ����
�� consnume��  � ����
�� conscase��  � ��� = MR��� o  MN���� 0 matchformat matchFormat� m  NQ��
�� SerECmpP� ��� L  U^�� I  U]������� "0 _replacepattern _replacePattern� ��� o  VW���� 0 thetext theText� ��� o  WX���� 0 fortext forText� ���� o  XY���� 0 newtext newText��  ��  � ��� = af��� o  ab���� 0 matchformat matchFormat� m  be��
�� SerECmpE� ��� P  i|���� L  r{�� I  rz������� 0 _replacetext _replaceText� ��� o  st���� 0 thetext theText� ��� o  tu���� 0 fortext forText� ���� o  uv���� 0 newtext newText��  ��  � ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ����
�� conswhit��  � ����
�� consnume��  � ��� = ���� o  ����� 0 matchformat matchFormat� m  ����
�� SerECmpC� ��� P  ������� L  ���� I  ��������� 0 _replacetext _replaceText� ��� o  ������ 0 thetext theText� ��� o  ������ 0 fortext forText� ���� o  ������ 0 newtext newText��  ��  � ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ��
� conswhit� �~�}
�~ consnume�}  ��  � ��� = ����� o  ���|�| 0 matchformat matchFormat� m  ���{
�{ SerECmpD� ��z� L  ���� I  ���y��x�y 0 _replacetext _replaceText� ��� o  ���w�w 0 thetext theText� ��� o  ���v�v 0 fortext forText� ��u� o  ���t�t 0 newtext newText�u  �x  �z  � n ����� I  ���s��r�s >0 throwinvalidconstantparameter throwInvalidConstantParameter� ��� o  ���q�q 0 matchformat matchFormat� ��p� m  ���� ��� 
 u s i n g�p  �r  � o  ���o�o 0 _support  �   replace matches   � ���     r e p l a c e   m a t c h e s�"  � R      �n��
�n .ascrerr ****      � ****� o      �m�m 0 etext eText� �l��
�l 
errn� o      �k�k 0 enumber eNumber� �j� 
�j 
erob� o      �i�i 0 efrom eFrom  �h�g
�h 
errt o      �f�f 
0 eto eTo�g  � I  ���e�d�e 
0 _error    m  �� �  s e a r c h   t e x t  o  ���c�c 0 etext eText 	
	 o  ���b�b 0 enumber eNumber
  o  ���a�a 0 efrom eFrom �` o  ���_�_ 
0 eto eTo�`  �d  �  l     �^�]�\�^  �]  �\    l     �[�Z�Y�[  �Z  �Y    i  ? B I     �X�W
�X .Txt:EPatnull���     ctxt o      �V�V 0 thetext theText�W   Q     * L     c     l   �U�T n    I    �S �R�S 40 escapedpatternforstring_ escapedPatternForString_  !�Q! l   "�P�O" n   #$# I    �N%�M�N "0 astextparameter asTextParameter% &'& o    �L�L 0 thetext theText' (�K( m    )) �**  �K  �M  $ o    �J�J 0 _support  �P  �O  �Q  �R   n   +,+ o    �I�I *0 nsregularexpression NSRegularExpression, m    �H
�H misccura�U  �T   m    �G
�G 
ctxt R      �F-.
�F .ascrerr ****      � ****- o      �E�E 0 etext eText. �D/0
�D 
errn/ o      �C�C 0 enumber eNumber0 �B12
�B 
erob1 o      �A�A 0 efrom eFrom2 �@3�?
�@ 
errt3 o      �>�> 
0 eto eTo�?   I     *�=4�<�= 
0 _error  4 565 m   ! "77 �88  e s c a p e   p a t t e r n6 9:9 o   " #�;�; 0 etext eText: ;<; o   # $�:�: 0 enumber eNumber< =>= o   $ %�9�9 0 efrom eFrom> ?�8? o   % &�7�7 
0 eto eTo�8  �<   @A@ l     �6�5�4�6  �5  �4  A BCB l     �3�2�1�3  �2  �1  C DED i  C FFGF I     �0H�/
�0 .Txt:ETemnull���     ctxtH o      �.�. 0 thetext theText�/  G Q     *IJKI L    LL c    MNM l   O�-�,O n   PQP I    �+R�*�+ 60 escapedtemplateforstring_ escapedTemplateForString_R S�)S l   T�(�'T n   UVU I    �&W�%�& "0 astextparameter asTextParameterW XYX o    �$�$ 0 thetext theTextY Z�#Z m    [[ �\\  �#  �%  V o    �"�" 0 _support  �(  �'  �)  �*  Q n   ]^] o    �!�! *0 nsregularexpression NSRegularExpression^ m    � 
�  misccura�-  �,  N m    �
� 
ctxtJ R      �_`
� .ascrerr ****      � ****_ o      �� 0 etext eText` �ab
� 
errna o      �� 0 enumber eNumberb �cd
� 
erobc o      �� 0 efrom eFromd �e�
� 
errte o      �� 
0 eto eTo�  K I     *�f�� 
0 _error  f ghg m   ! "ii �jj  e s c a p e   t e m p l a t eh klk o   " #�� 0 etext eTextl mnm o   # $�� 0 enumber eNumbern opo o   $ %�� 0 efrom eFromp q�q o   % &�� 
0 eto eTo�  �  E rsr l     ����  �  �  s tut l     ��
�	�  �
  �	  u vwv l     �xy�  x J D--------------------------------------------------------------------   y �zz � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -w {|{ l     �}~�  }   Conversion Suite   ~ � "   C o n v e r s i o n   S u i t e| ��� l     ����  �  �  � ��� i  G J��� I     ���
� .Txt:UppTnull���     ctxt� o      �� 0 thetext theText� ��� 
� 
Loca� |����������  ��  � o      ���� 0 
localecode 
localeCode��  � l     ������ m      �� ���  n o n e��  ��  �   � Q     P���� k    >�� ��� r    ��� n   ��� I    ������� 0 
asnsstring 
asNSString� ���� n   ��� I    ������� "0 astextparameter asTextParameter� ��� o    ���� 0 thetext theText� ���� m    �� ���  ��  ��  � o    ���� 0 _support  ��  ��  � o    ���� 0 _support  � o      ���� 0 
asocstring 
asocString� ���� Z    >������ =   ��� o    ���� 0 
localecode 
localeCode� m    ��
�� 
msng� L     (�� c     '��� l    %������ n    %��� I   ! %�������� "0 uppercasestring uppercaseString��  ��  � o     !���� 0 
asocstring 
asocString��  ��  � m   % &��
�� 
ctxt��  � L   + >�� c   + =��� l  + ;������ n  + ;��� I   , ;������� 80 uppercasestringwithlocale_ uppercaseStringWithLocale_� ���� l  , 7������ n  , 7��� I   1 7������� *0 asnslocaleparameter asNSLocaleParameter� ��� o   1 2���� 0 
localecode 
localeCode� ���� m   2 3�� ���  f o r   l o c a l e��  ��  � o   , 1���� 0 _support  ��  ��  ��  ��  � o   + ,���� 0 
asocstring 
asocString��  ��  � m   ; <��
�� 
ctxt��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I   F P������� 
0 _error  � ��� m   G H�� ���  u p p e r c a s e   t e x t� ��� o   H I���� 0 etext eText� ��� o   I J���� 0 enumber eNumber� ��� o   J K���� 0 efrom eFrom� ���� o   K L���� 
0 eto eTo��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  K N��� I     ����
�� .Txt:CapTnull���     ctxt� o      ���� 0 thetext theText� �����
�� 
Loca� |����������  ��  � o      ���� 0 
localecode 
localeCode��  � l     ������ m      �� ���  n o n e��  ��  ��  � Q     P���� k    >�� ��� r    ��� n   ��� I    ������� 0 
asnsstring 
asNSString� ���� n   ��� I    ������� "0 astextparameter asTextParameter� ��� o    ���� 0 thetext theText� ���� m    �� ���  ��  ��  � o    ���� 0 _support  ��  ��  � o    ���� 0 _support  � o      ���� 0 
asocstring 
asocString� ���� Z    >������ =   ��� o    ���� 0 
localecode 
localeCode� m    ��
�� 
msng� L     (�� c     '��� l    %������ n    %   I   ! %�������� &0 capitalizedstring capitalizedString��  ��   o     !���� 0 
asocstring 
asocString��  ��  � m   % &��
�� 
ctxt��  � L   + > c   + = l  + ;���� n  + ; I   , ;������ <0 capitalizedstringwithlocale_ capitalizedStringWithLocale_ 	��	 l  , 7
����
 n  , 7 I   1 7������ *0 asnslocaleparameter asNSLocaleParameter  o   1 2���� 0 
localecode 
localeCode �� m   2 3 �  f o r   l o c a l e��  ��   o   , 1���� 0 _support  ��  ��  ��  ��   o   + ,���� 0 
asocstring 
asocString��  ��   m   ; <��
�� 
ctxt��  � R      ��
�� .ascrerr ****      � **** o      ���� 0 etext eText ��
�� 
errn o      ���� 0 enumber eNumber ��
�� 
erob o      ���� 0 efrom eFrom ����
�� 
errt o      ���� 
0 eto eTo��  � I   F P������ 
0 _error    m   G H �  c a p i t a l i z e   t e x t   o   H I���� 0 etext eText  !"! o   I J���� 0 enumber eNumber" #$# o   J K���� 0 efrom eFrom$ %��% o   K L���� 
0 eto eTo��  ��  � &'& l     ��������  ��  ��  ' ()( l     ����~��  �  �~  ) *+* i  O R,-, I     �}./
�} .Txt:LowTnull���     ctxt. o      �|�| 0 thetext theText/ �{0�z
�{ 
Loca0 |�y�x1�w2�y  �x  1 o      �v�v 0 
localecode 
localeCode�w  2 l     3�u�t3 m      44 �55  n o n e�u  �t  �z  - Q     P6786 k    >99 :;: r    <=< n   >?> I    �s@�r�s 0 
asnsstring 
asNSString@ A�qA n   BCB I    �pD�o�p "0 astextparameter asTextParameterD EFE o    �n�n 0 thetext theTextF G�mG m    HH �II  �m  �o  C o    �l�l 0 _support  �q  �r  ? o    �k�k 0 _support  = o      �j�j 0 
asocstring 
asocString; J�iJ Z    >KL�hMK =   NON o    �g�g 0 
localecode 
localeCodeO m    �f
�f 
msngL L     (PP c     'QRQ l    %S�e�dS n    %TUT I   ! %�c�b�a�c "0 lowercasestring lowercaseString�b  �a  U o     !�`�` 0 
asocstring 
asocString�e  �d  R m   % &�_
�_ 
ctxt�h  M L   + >VV c   + =WXW l  + ;Y�^�]Y n  + ;Z[Z I   , ;�\\�[�\ 80 lowercasestringwithlocale_ lowercaseStringWithLocale_\ ]�Z] l  , 7^�Y�X^ n  , 7_`_ I   1 7�Wa�V�W *0 asnslocaleparameter asNSLocaleParametera bcb o   1 2�U�U 0 
localecode 
localeCodec d�Td m   2 3ee �ff  f o r   l o c a l e�T  �V  ` o   , 1�S�S 0 _support  �Y  �X  �Z  �[  [ o   + ,�R�R 0 
asocstring 
asocString�^  �]  X m   ; <�Q
�Q 
ctxt�i  7 R      �Pgh
�P .ascrerr ****      � ****g o      �O�O 0 etext eTexth �Nij
�N 
errni o      �M�M 0 enumber eNumberj �Lkl
�L 
erobk o      �K�K 0 efrom eFroml �Jm�I
�J 
errtm o      �H�H 
0 eto eTo�I  8 I   F P�Gn�F�G 
0 _error  n opo m   G Hqq �rr  l o w e r c a s e   t e x tp sts o   H I�E�E 0 etext eTextt uvu o   I J�D�D 0 enumber eNumberv wxw o   J K�C�C 0 efrom eFromx y�By o   K L�A�A 
0 eto eTo�B  �F  + z{z l     �@�?�>�@  �?  �>  { |}| l     �=�<�;�=  �<  �;  } ~~ i  S V��� I     �:��
�: .Txt:FTxtnull���     ctxt� o      �9�9 0 templatetext templateText� �8��7
�8 
Usin� o      �6�6 0 	thevalues 	theValues�7  � k    [�� ��� l     �5���5  � � � note: templateText uses same `$n` (where n=1-9) notation as `search text`'s replacement templates, with `\$` to escape as necessary ($ not followed by a digit will appear as-is)   � ���d   n o t e :   t e m p l a t e T e x t   u s e s   s a m e   ` $ n `   ( w h e r e   n = 1 - 9 )   n o t a t i o n   a s   ` s e a r c h   t e x t ` ' s   r e p l a c e m e n t   t e m p l a t e s ,   w i t h   ` \ $ `   t o   e s c a p e   a s   n e c e s s a r y   ( $   n o t   f o l l o w e d   b y   a   d i g i t   w i l l   a p p e a r   a s - i s )� ��4� Q    [���� P   A���� k   @�� ��� r    ��� n   ��� I    �3��2�3 "0 aslistparameter asListParameter� ��1� o    �0�0 0 	thevalues 	theValues�1  �2  � o    �/�/ 0 _support  � o      �.�. 0 	thevalues 	theValues� ��� l   !���� r    !��� n   ��� I    �-��,�- Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_� ��� m    �� ���  \ \ . | \ $ [ 1 - 9 ]� ��� m    �+�+  � ��*� l   ��)�(� m    �'
�' 
msng�)  �(  �*  �,  � n   ��� o    �&�& *0 nsregularexpression NSRegularExpression� m    �%
�% misccura� o      �$�$ 0 asocpattern asocPattern� E ? match any backslash escaped character or a $ followed by digit   � ��� ~   m a t c h   a n y   b a c k s l a s h   e s c a p e d   c h a r a c t e r   o r   a   $   f o l l o w e d   b y   d i g i t� ��� r   " .��� n  " ,��� I   ' ,�#��"�# 0 
asnsstring 
asNSString� ��!� o   ' (� �  0 templatetext templateText�!  �"  � o   " '�� 0 _support  � o      �� 0 
asocstring 
asocString� ��� r   / @��� l  / >���� n  / >��� I   0 >���� @0 matchesinstring_options_range_ matchesInString_options_range_� ��� o   0 1�� 0 
asocstring 
asocString� ��� m   1 2��  � ��� J   2 :�� ��� m   2 3��  � ��� n  3 8��� I   4 8���� 
0 length  �  �  � o   3 4�� 0 
asocstring 
asocString�  �  �  � o   / 0�� 0 asocpattern asocPattern�  �  � o      ��  0 asocmatcharray asocMatchArray� ��� r   A E��� J   A C��  � o      �� 0 resulttexts resultTexts� ��� r   F I��� m   F G��  � o      �� 0 
startindex 
startIndex� ��� Y   J��
���	� k   Z�� ��� r   Z g��� l  Z e���� n  Z e��� I   ` e���� 0 rangeatindex_ rangeAtIndex_� ��� m   ` a��  �  �  � l  Z `���� n  Z `��� I   [ `� ����   0 objectatindex_ objectAtIndex_� ���� o   [ \���� 0 i  ��  ��  � o   Z [����  0 asocmatcharray asocMatchArray�  �  �  �  � o      ���� 0 
matchrange 
matchRange� ��� r   h ���� c   h }��� l  h y������ n  h y��� I   i y������� *0 substringwithrange_ substringWithRange_� ���� K   i u�� ������ 0 location  � o   j k���� 0 
startindex 
startIndex� ������� 
0 length  � l  l s������ \   l s��� l  l q������ n  l q��� I   m q�������� 0 location  ��  ��  � o   l m���� 0 
matchrange 
matchRange��  ��  � o   q r���� 0 
startindex 
startIndex��  ��  ��  ��  ��  � o   h i���� 0 
asocstring 
asocString��  ��  � m   y |��
�� 
ctxt� n      ���  ;   ~ � o   } ~���� 0 resulttexts resultTexts� ��� r   � �	 		  c   � �			 l  � �	����	 n  � �			 I   � ���	���� *0 substringwithrange_ substringWithRange_	 	��	 o   � ����� 0 
matchrange 
matchRange��  ��  	 o   � ����� 0 
asocstring 
asocString��  ��  	 m   � ���
�� 
ctxt	 o      ���� 0 thetoken theToken� 			
		 Z   � �		��		 =  � �			 n  � �			 4   � ���	
�� 
cha 	 m   � ����� 	 o   � ����� 0 thetoken theToken	 m   � �		 �		  \	 l  � �				 l  � �				 r   � �			 n  � �			 4   � ���	
�� 
cha 	 m   � ����� 	 o   � ����� 0 thetoken theToken	 n      	 	!	   ;   � �	! o   � ����� 0 resulttexts resultTexts	 w q �so insert the character that follows it -- TO DO: should this support 'special' character escapes, \t, \n, etc?   	 �	"	" �   & s o   i n s e r t   t h e   c h a r a c t e r   t h a t   f o l l o w s   i t   - -   T O   D O :   s h o u l d   t h i s   s u p p o r t   ' s p e c i a l '   c h a r a c t e r   e s c a p e s ,   \ t ,   \ n ,   e t c ?	 + % found a backslash-escaped character�   	 �	#	# J   f o u n d   a   b a c k s l a s h - e s c a p e d   c h a r a c t e r &��  	 l  � �	$	%	&	$ k   � �	'	' 	(	)	( r   � �	*	+	* c   � �	,	-	, n  � �	.	/	. 4   � ���	0
�� 
cha 	0 m   � ����� 	/ o   � ����� 0 thetoken theToken	- m   � ���
�� 
long	+ o      ���� 0 	itemindex 	itemIndex	) 	1	2	1 l  � �	3	4	5	3 r   � �	6	7	6 n   � �	8	9	8 4   � ���	:
�� 
cobj	: o   � ����� 0 	itemindex 	itemIndex	9 o   � ����� 0 	thevalues 	theValues	7 o      ���� 0 theitem theItem	4 < 6 raises error -1728 if itemIndex > length of theValues   	5 �	;	; l   r a i s e s   e r r o r   - 1 7 2 8   i f   i t e m I n d e x   >   l e n g t h   o f   t h e V a l u e s	2 	<��	< Q   � �	=	>	?	= r   � �	@	A	@ c   � �	B	C	B o   � ����� 0 theitem theItem	C m   � ���
�� 
ctxt	A n      	D	E	D  ;   � �	E o   � ����� 0 resulttexts resultTexts	> R      ����	F
�� .ascrerr ****      � ****��  	F ��	G��
�� 
errn	G d      	H	H m      �������  	? R   � ���	I	J
�� .ascrerr ****      � ****	I b   � �	K	L	K b   � �	M	N	M m   � �	O	O �	P	P & C a n  t   c o n v e r t   i t e m  	N o   � ����� 0 	itemindex 	itemIndex	L m   � �	Q	Q �	R	R    t o   t e x t .	J ��	S	T
�� 
errn	S m   � ������\	T ��	U	V
�� 
erob	U l  � �	W����	W N   � �	X	X n   � �	Y	Z	Y 4   � ���	[
�� 
cobj	[ o   � ����� 0 	itemindex 	itemIndex	Z o   � ����� 0 	thevalues 	theValues��  ��  	V ��	\��
�� 
errt	\ m   � ���
�� 
ctxt��  ��  	%  	 found $n   	& �	]	]    f o u n d   $ n	
 	^��	^ r   �	_	`	_ [   � 	a	b	a l  � �	c����	c n  � �	d	e	d I   � ��������� 0 location  ��  ��  	e o   � ����� 0 
matchrange 
matchRange��  ��  	b l  � �	f����	f n  � �	g	h	g I   � ��������� 
0 length  ��  ��  	h o   � ����� 0 
matchrange 
matchRange��  ��  	` o      ���� 0 
startindex 
startIndex��  �
 0 i  � m   M N����  � l  N U	i����	i \   N U	j	k	j l  N S	l����	l n  N S	m	n	m I   O S�������� 	0 count  ��  ��  	n o   N O����  0 asocmatcharray asocMatchArray��  ��  	k m   S T���� ��  ��  �	  � 	o	p	o r  	q	r	q c  	s	t	s l 	u����	u n 	v	w	v I  	��	x���� *0 substringfromindex_ substringFromIndex_	x 	y��	y o  	
���� 0 
startindex 
startIndex��  ��  	w o  	���� 0 
asocstring 
asocString��  ��  	t m  ��
�� 
ctxt	r n      	z	{	z  ;  	{ o  ���� 0 resulttexts resultTexts	p 	|	}	| r  	~		~ n 	�	�	� 1  ��
�� 
txdl	� 1  ��
�� 
ascr	 o      ���� 0 oldtids oldTIDs	} 	�	�	� r   +	�	�	� m   #	�	� �	�	�  	� n     	�	�	� 1  &*��
�� 
txdl	� 1  #&��
�� 
ascr	� 	�	�	� r  ,3	�	�	� c  ,1	�	�	� o  ,-���� 0 resulttexts resultTexts	� m  -0��
�� 
ctxt	� o      ���� 0 
resulttext 
resultText	� 	�	�	� r  4=	�	�	� o  45���� 0 oldtids oldTIDs	� n     	�	�	� 1  8<��
�� 
txdl	� 1  58��
�� 
ascr	� 	���	� L  >@	�	� o  >?���� 0 
resulttext 
resultText��  � ��	�
�� conscase	� ��	�
�� consdiac	� ��	�
�� conshyph	� ��	�
�� conspunc	� ����
�� conswhit��  � ����
�� consnume��  � R      �	�	�
� .ascrerr ****      � ****	� o      �~�~ 0 etext eText	� �}	�	�
�} 
errn	� o      �|�| 0 enumber eNumber	� �{	�	�
�{ 
erob	� o      �z�z 0 efrom eFrom	� �y	��x
�y 
errt	� o      �w�w 
0 eto eTo�x  � I  I[�v	��u�v 
0 _error  	� 	�	�	� m  JM	�	� �	�	�  f o r m a t   t e x t	� 	�	�	� o  MN�t�t 0 etext eText	� 	�	�	� o  NO�s�s 0 enumber eNumber	� 	�	�	� o  OR�r�r 0 efrom eFrom	� 	��q	� o  RU�p�p 
0 eto eTo�q  �u  �4   	�	�	� l     �o�n�m�o  �n  �m  	� 	�	�	� l     �l�k�j�l  �k  �j  	� 	�	�	� i  W Z	�	�	� I     �i	�	�
�i .Txt:NLiBnull���     ctxt	� o      �h�h 0 thetext theText	� �g	��f
�g 
LiBr	� |�e�d	��c	��e  �d  	� o      �b�b 0 linebreaktype lineBreakType�c  	� l     	��a�`	� m      �_
�_ LiBrLiOX�a  �`  �f  	� Q     .	�	�	�	� L    	�	� I    �^	��]�^ 0 	_jointext 	_joinText	� 	�	�	� n   	�	�	� 2   �\
�\ 
cpar	� n   	�	�	� I   	 �[	��Z�[ "0 astextparameter asTextParameter	� 	�	�	� o   	 
�Y�Y 0 thetext theText	� 	��X	� m   
 	�	� �	�	�  �X  �Z  	� o    	�W�W 0 _support  	� 	��V	� I    �U	��T�U 0 
_linebreak  	� 	��S	� o    �R�R 0 linebreaktype lineBreakType�S  �T  �V  �]  	� R      �Q	�	�
�Q .ascrerr ****      � ****	� o      �P�P 0 etext eText	� �O	�	�
�O 
errn	� o      �N�N 0 enumber eNumber	� �M	�	�
�M 
erob	� o      �L�L 0 efrom eFrom	� �K	��J
�K 
errt	� o      �I�I 
0 eto eTo�J  	� I   $ .�H	��G�H 
0 _error  	� 	�	�	� m   % &	�	� �	�	� * n o r m a l i z e   l i n e   b r e a k s	� 	�	�	� o   & '�F�F 0 etext eText	� 	�	�	� o   ' (�E�E 0 enumber eNumber	� 	�	�	� o   ( )�D�D 0 efrom eFrom	� 	��C	� o   ) *�B�B 
0 eto eTo�C  �G  	� 	�	�	� l     �A�@�?�A  �@  �?  	� 	�	�	� l     �>�=�<�>  �=  �<  	� 	�	�	� i  [ ^	�	�	� I     �;	�	�
�; .Txt:PadTnull���     ctxt	� o      �:�: 0 thetext theText	� �9	�	�
�9 
toPl	� o      �8�8 0 	textwidth 	textWidth	� �7	�	�
�7 
Char	� |�6�5	��4	��6  �5  	� o      �3�3 0 padtext padText�4  	� l     	��2�1	� m      	�	� �	�	�                                  �2  �1  	� �0	��/
�0 
From	� |�.�-	��,	��.  �-  	� o      �+�+ 0 whichend whichEnd�,  	� l     	��*�)	� m      �(
�( LeTrLCha�*  �)  �/  	� Q    	�	�	�	� k    �	�	� 	�
 	� r    


 n   


 I    �'
�&�' "0 astextparameter asTextParameter
 


 o    	�%�% 0 thetext theText
 
�$
 m   	 

	
	 �



  �$  �&  
 o    �#�# 0 _support  
 o      �"�" 0 thetext theText
  


 r    


 n   


 I    �!
� �! (0 asintegerparameter asIntegerParameter
 


 o    �� 0 	textwidth 	textWidth
 
�
 m    

 �

  t o   p l a c e s�  �   
 o    �� 0 _support  
 o      �� 0 	textwidth 	textWidth
 


 r    &


 \    $


 o     �� 0 	textwidth 	textWidth
 l    #
��
 n    #


 1   ! #�
� 
leng
 o     !�� 0 thetext theText�  �  
 o      �� 0 
widthtoadd 
widthToAdd
 
 
!
  Z  ' 3
"
#��
" B   ' *
$
%
$ o   ' (�� 0 
widthtoadd 
widthToAdd
% m   ( )��  
# L   - /
&
& o   - .�� 0 thetext theText�  �  
! 
'
(
' r   4 A
)
*
) n  4 ?
+
,
+ I   9 ?�
-�� "0 astextparameter asTextParameter
- 
.
/
. o   9 :�� 0 padtext padText
/ 
0�
0 m   : ;
1
1 �
2
2 
 u s i n g�  �  
, o   4 9�� 0 _support  
* o      �� 0 padtext padText
( 
3
4
3 r   B G
5
6
5 n  B E
7
8
7 1   C E�

�
 
leng
8 o   B C�	�	 0 padtext padText
6 o      �� 0 padsize padSize
4 
9
:
9 Z  H \
;
<��
; =   H M
=
>
= n  H K
?
@
? 1   I K�
� 
leng
@ o   H I�� 0 padtext padText
> m   K L��  
< R   P X�
A
B
� .ascrerr ****      � ****
A m   V W
C
C �
D
D f I n v a l i d    u s i n g    p a r a m e t e r   ( e m p t y   t e x t   n o t   a l l o w e d ) .
B �
E
F
� 
errn
E m   R S� � �Y
F ��
G��
�� 
erob
G o   T U���� 0 padtext padText��  �  �  
: 
H
I
H V   ] s
J
K
J r   i n
L
M
L b   i l
N
O
N o   i j���� 0 padtext padText
O o   j k���� 0 padtext padText
M o      ���� 0 padtext padText
K A   a h
P
Q
P n  a d
R
S
R 1   b d��
�� 
leng
S o   a b���� 0 padtext padText
Q l  d g
T����
T [   d g
U
V
U o   d e���� 0 
widthtoadd 
widthToAdd
V o   e f���� 0 padsize padSize��  ��  
I 
W��
W Z   t �
X
Y
Z
[
X =  t w
\
]
\ o   t u���� 0 whichend whichEnd
] m   u v��
�� LeTrLCha
Y L   z �
^
^ b   z �
_
`
_ l  z �
a����
a n  z �
b
c
b 7  { ���
d
e
�� 
ctxt
d m    ����� 
e o   � ����� 0 
widthtoadd 
widthToAdd
c o   z {���� 0 padtext padText��  ��  
` o   � ����� 0 thetext theText
Z 
f
g
f =  � �
h
i
h o   � ����� 0 whichend whichEnd
i m   � ���
�� LeTrTCha
g 
j
k
j k   � �
l
l 
m
n
m r   � �
o
p
o `   � �
q
r
q l  � �
s����
s n  � �
t
u
t 1   � ���
�� 
leng
u o   � ����� 0 thetext theText��  ��  
r o   � ����� 0 padsize padSize
p o      ���� 0 	padoffset 	padOffset
n 
v��
v L   � �
w
w b   � �
x
y
x o   � ����� 0 thetext theText
y l  � �
z����
z n  � �
{
|
{ 7  � ���
}
~
�� 
ctxt
} l  � �
����
 [   � �
�
�
� m   � ����� 
� o   � ����� 0 	padoffset 	padOffset��  ��  
~ l  � �
�����
� [   � �
�
�
� o   � ����� 0 	padoffset 	padOffset
� o   � ����� 0 
widthtoadd 
widthToAdd��  ��  
| o   � ����� 0 padtext padText��  ��  ��  
k 
�
�
� =  � �
�
�
� o   � ����� 0 whichend whichEnd
� m   � ���
�� LeTrBCha
� 
���
� k   � �
�
� 
�
�
� Z  � �
�
�����
� ?   � �
�
�
� o   � ����� 0 
widthtoadd 
widthToAdd
� m   � ����� 
� r   � �
�
�
� b   � �
�
�
� n  � �
�
�
� 7  � ���
�
�
�� 
ctxt
� m   � ����� 
� l  � �
�����
� _   � �
�
�
� o   � ����� 0 
widthtoadd 
widthToAdd
� m   � ����� ��  ��  
� o   � ����� 0 padtext padText
� o   � ����� 0 thetext theText
� o      ���� 0 thetext theText��  ��  
� 
�
�
� r   � �
�
�
� `   � �
�
�
� l  � �
�����
� n  � �
�
�
� 1   � ���
�� 
leng
� o   � ����� 0 thetext theText��  ��  
� o   � ����� 0 padsize padSize
� o      ���� 0 	padoffset 	padOffset
� 
���
� L   � �
�
� b   � �
�
�
� o   � ����� 0 thetext theText
� l  � �
�����
� n  � �
�
�
� 7  � ���
�
�
�� 
ctxt
� l  � �
�����
� [   � �
�
�
� m   � ����� 
� o   � ����� 0 	padoffset 	padOffset��  ��  
� l  � �
�����
� [   � �
�
�
� o   � ����� 0 	padoffset 	padOffset
� _   � �
�
�
� l  � �
�����
� [   � �
�
�
� o   � ����� 0 
widthtoadd 
widthToAdd
� m   � ����� ��  ��  
� m   � ����� ��  ��  
� o   � ����� 0 padtext padText��  ��  ��  ��  
[ n  � �
�
�
� I   � ���
����� >0 throwinvalidconstantparameter throwInvalidConstantParameter
� 
�
�
� o   � ����� 0 whichend whichEnd
� 
���
� m   � �
�
� �
�
�  a d d i n g��  ��  
� o   � ����� 0 _support  ��  	� R      ��
�
�
�� .ascrerr ****      � ****
� o      ���� 0 etext eText
� ��
�
�
�� 
errn
� o      ���� 0 enumber eNumber
� ��
�
�
�� 
erob
� o      ���� 0 efrom eFrom
� ��
���
�� 
errt
� o      ���� 
0 eto eTo��  	� I  ��
����� 
0 _error  
� 
�
�
� m  
�
� �
�
�  p a d   t e x t
� 
�
�
� o  	���� 0 etext eText
� 
�
�
� o  	
���� 0 enumber eNumber
� 
�
�
� o  
���� 0 efrom eFrom
� 
���
� o  ���� 
0 eto eTo��  ��  	� 
�
�
� l     ��������  ��  ��  
� 
�
�
� l     ��������  ��  ��  
� 
�
�
� i  _ b
�
�
� I     ��
�
�
�� .Txt:SliTnull���     ctxt
� o      ���� 0 thetext theText
� ��
�
�
�� 
FIdx
� |����
���
���  ��  
� o      ���� 0 
startindex 
startIndex��  
� l     
�����
� m      ��
�� 
msng��  ��  
� ��
���
�� 
TIdx
� |����
���
���  ��  
� o      ���� 0 endindex endIndex��  
� l     
����
� m      �~
�~ 
msng��  �  ��  
� Q    �
�
�
�
� k   �
�
� 
�
�
� r    
�
�
� n   
�
�
� I    �}
��|�} "0 astextparameter asTextParameter
� 
�
�
� o    	�{�{ 0 thetext theText
� 
��z
� m   	 

�
� �
�
�  �z  �|  
� o    �y�y 0 _support  
� o      �x�x 0 thetext theText
� 
�
�
� r    
�
�
� n   
�
�
� 1    �w
�w 
leng
� o    �v�v 0 thetext theText
� o      �u�u 0 	thelength 	theLength
� 
�
�
� Z    I
� �t�s
� =     o    �r�r 0 	thelength 	theLength m    �q�q    k    E  l   �p�p   � � note: index 0 is always disallowed as its position is ambiguous, being both before index 1 at start of text and after index -1 at end of text    �   n o t e :   i n d e x   0   i s   a l w a y s   d i s a l l o w e d   a s   i t s   p o s i t i o n   i s   a m b i g u o u s ,   b e i n g   b o t h   b e f o r e   i n d e x   1   a t   s t a r t   o f   t e x t   a n d   a f t e r   i n d e x   - 1   a t   e n d   o f   t e x t 	
	 Z   /�o�n =      o    �m�m 0 
startindex 
startIndex m    �l�l   R   # +�k
�k .ascrerr ****      � **** m   ) * � Z I n v a l i d   i n d e x   (  f r o m    p a r a m e t e r   c a n n o t   b e   0 ) . �j
�j 
errn m   % &�i�i�Y �h�g
�h 
erob o   ' (�f�f 0 
startindex 
startIndex�g  �o  �n  
  Z  0 B�e�d =   0 3 o   0 1�c�c 0 endindex endIndex m   1 2�b�b   R   6 >�a
�a .ascrerr ****      � **** m   < = � V I n v a l i d   i n d e x   (  t o    p a r a m e t e r   c a n n o t   b e   0 ) . �` !
�` 
errn  m   8 9�_�_�Y! �^"�]
�^ 
erob" o   : ;�\�\ 0 endindex endIndex�]  �e  �d   #�[# L   C E$$ m   C D%% �&&  �[  �t  �s  
� '(' Z   J �)*+�Z) >  J M,-, o   J K�Y�Y 0 
startindex 
startIndex- m   K L�X
�X 
msng* k   P �.. /0/ r   P ]121 n  P [343 I   U [�W5�V�W (0 asintegerparameter asIntegerParameter5 676 o   U V�U�U 0 
startindex 
startIndex7 8�T8 m   V W99 �::  f r o m�T  �V  4 o   P U�S�S 0 _support  2 o      �R�R 0 
startindex 
startIndex0 ;<; Z  ^ p=>�Q�P= =   ^ a?@? o   ^ _�O�O 0 
startindex 
startIndex@ m   _ `�N�N  > R   d l�MAB
�M .ascrerr ****      � ****A m   j kCC �DD Z I n v a l i d   i n d e x   (  f r o m    p a r a m e t e r   c a n n o t   b e   0 ) .B �LEF
�L 
errnE m   f g�K�K�YF �JG�I
�J 
erobG o   h i�H�H 0 
startindex 
startIndex�I  �Q  �P  < H�GH Z   q �IJ�F�EI =  q tKLK o   q r�D�D 0 endindex endIndexL m   r s�C
�C 
msngJ Z   w �MNOPM A   w {QRQ o   w x�B�B 0 
startindex 
startIndexR d   x zSS o   x y�A�A 0 	thelength 	theLengthN L   ~ �TT o   ~ �@�@ 0 thetext theTextO UVU ?   � �WXW o   � ��?�? 0 
startindex 
startIndexX o   � ��>�> 0 	thelength 	theLengthV Y�=Y L   � �ZZ m   � �[[ �\\  �=  P L   � �]] n  � �^_^ 7  � ��<`a
�< 
ctxt` o   � ��;�; 0 
startindex 
startIndexa m   � ��:�:��_ o   � ��9�9 0 thetext theText�F  �E  �G  + bcb =  � �ded o   � ��8�8 0 endindex endIndexe m   � ��7
�7 
msngc f�6f R   � ��5gh
�5 .ascrerr ****      � ****g m   � �ii �jj J M i s s i n g    f r o m    a n d / o r    t o    p a r a m e t e r .h �4k�3
�4 
errnk m   � ��2�2�[�3  �6  �Z  ( lml Z   �no�1�0n >  � �pqp o   � ��/�/ 0 endindex endIndexq m   � ��.
�. 
msngo k   �rr sts r   � �uvu n  � �wxw I   � ��-y�,�- (0 asintegerparameter asIntegerParametery z{z o   � ��+�+ 0 endindex endIndex{ |�*| m   � �}} �~~  t o�*  �,  x o   � ��)�) 0 _support  v o      �(�( 0 endindex endIndext � Z  � ����'�&� =   � ���� o   � ��%�% 0 endindex endIndex� m   � ��$�$  � R   � ��#��
�# .ascrerr ****      � ****� m   � ��� ��� V I n v a l i d   i n d e x   (  t o    p a r a m e t e r   c a n n o t   b e   0 ) .� �"��
�" 
errn� m   � ��!�!�Y� � ��
�  
erob� o   � ��� 0 endindex endIndex�  �'  �&  � ��� Z   ������ =  � ���� o   � ��� 0 
startindex 
startIndex� m   � ��
� 
msng� Z   ������ A   � ���� o   � ��� 0 endindex endIndex� d   � ��� o   � ��� 0 	thelength 	theLength� L   � ��� m   � ��� ���  � ��� ?   � ���� o   � ��� 0 endindex endIndex� o   � ��� 0 	thelength 	theLength� ��� L   � ��� o   � ��� 0 thetext theText�  � L  �� n ��� 7 ���
� 
ctxt� m  �� � o  	�� 0 endindex endIndex� o  �� 0 thetext theText�  �  �  �1  �0  m ��� l ����  � + % both start and end indexes are given   � ��� J   b o t h   s t a r t   a n d   e n d   i n d e x e s   a r e   g i v e n� ��� Z (����� A  ��� o  �� 0 
startindex 
startIndex� m  �
�
  � r  $��� [  "��� [   ��� o  �	�	 0 	thelength 	theLength� m  �� � o   !�� 0 
startindex 
startIndex� o      �� 0 
startindex 
startIndex�  �  � ��� Z ):����� A  ),��� o  )*�� 0 endindex endIndex� m  *+��  � r  /6��� [  /4��� [  /2��� o  /0�� 0 	thelength 	theLength� m  01� �  � o  23���� 0 endindex endIndex� o      ���� 0 endindex endIndex�  �  � ��� Z ;q������� G  ;f��� G  ;R��� ?  ;>��� o  ;<���� 0 
startindex 
startIndex� o  <=���� 0 endindex endIndex� F  AN��� A  AD��� o  AB���� 0 
startindex 
startIndex� m  BC���� � A  GJ��� o  GH���� 0 endindex endIndex� l 
HI������ m  HI���� ��  ��  � F  Ub��� ?  UX��� o  UV���� 0 
startindex 
startIndex� o  VW���� 0 	thelength 	theLength� ?  [^��� o  [\���� 0 endindex endIndex� o  \]���� 0 	thelength 	theLength� L  im�� m  il�� ���  ��  ��  � ��� Z  r������� A  ru��� o  rs���� 0 
startindex 
startIndex� m  st���� � r  x{��� m  xy���� � o      ���� 0 
startindex 
startIndex� ��� ?  ~���� o  ~���� 0 
startindex 
startIndex� o  ����� 0 	thelength 	theLength� ���� r  ����� o  ������ 0 	thelength 	theLength� o      ���� 0 
startindex 
startIndex��  ��  � ��� Z  �������� A  ����� o  ������ 0 endindex endIndex� m  ������ � r  ����� m  ������ � o      ���� 0 endindex endIndex� ��� ?  ����� o  ������ 0 endindex endIndex� o  ������ 0 	thelength 	theLength� ���� r  ����� o  ������ 0 	thelength 	theLength� o      ���� 0 endindex endIndex��  ��  � ���� L  ���� n  ��� � 7 ����
�� 
ctxt o  ������ 0 
startindex 
startIndex o  ������ 0 endindex endIndex  o  ������ 0 thetext theText��  
� R      ��
�� .ascrerr ****      � **** o      ���� 0 etext eText ��
�� 
errn o      ���� 0 enumber eNumber ��
�� 
erob o      ���� 0 efrom eFrom ��	��
�� 
errt	 o      ���� 
0 eto eTo��  
� I  ����
���� 
0 _error  
  m  �� �  s l i c e   t e x t  o  ������ 0 etext eText  o  ������ 0 enumber eNumber  o  ������ 0 efrom eFrom �� o  ������ 
0 eto eTo��  ��  
�  l     ��������  ��  ��    l     ��������  ��  ��    i  c f I     ��
�� .Txt:TrmTnull���     ctxt o      ���� 0 thetext theText �� ��
�� 
From  |����!��"��  ��  ! o      ���� 0 whichend whichEnd��  " l     #����# m      ��
�� LeTrBCha��  ��  ��   Q     �$%&$ k    �'' ()( r    *+* n   ,-, I    ��.���� "0 astextparameter asTextParameter. /0/ o    	���� 0 thetext theText0 1��1 m   	 
22 �33  ��  ��  - o    ���� 0 _support  + o      ���� 0 thetext theText) 454 Z    -67����6 H    88 E   9:9 J    ;; <=< m    ��
�� LeTrLCha= >?> m    ��
�� LeTrTCha? @��@ m    ��
�� LeTrBCha��  : J    AA B��B o    ���� 0 whichend whichEnd��  7 n   )CDC I   # )��E���� >0 throwinvalidconstantparameter throwInvalidConstantParameterE FGF o   # $���� 0 whichend whichEndG H��H m   $ %II �JJ  r e m o v i n g��  ��  D o    #���� 0 _support  ��  ��  5 K��K P   . �LMNL k   3 �OO PQP l  3 ?RSTR Z  3 ?UV����U =  3 6WXW o   3 4���� 0 thetext theTextX m   4 5YY �ZZ  V L   9 ;[[ m   9 :\\ �]]  ��  ��  S H B check if theText is empty or contains white space characters only   T �^^ �   c h e c k   i f   t h e T e x t   i s   e m p t y   o r   c o n t a i n s   w h i t e   s p a c e   c h a r a c t e r s   o n l yQ _`_ r   @ Saba J   @ Dcc ded m   @ A���� e f��f m   A B��������  b J      gg hih o      ���� 0 
startindex 
startIndexi j��j o      ���� 0 endindex endIndex��  ` klk Z   T xmn����m E  T \opo J   T Xqq rsr m   T U��
�� LeTrLChas t��t m   U V��
�� LeTrBCha��  p J   X [uu v��v o   X Y���� 0 whichend whichEnd��  n V   _ twxw r   j oyzy [   j m{|{ o   j k���� 0 
startindex 
startIndex| m   k l���� z o      ���� 0 
startindex 
startIndexx =  c i}~} n   c g� 4   d g���
�� 
cha � o   e f���� 0 
startindex 
startIndex� o   c d���� 0 thetext theText~ m   g h�� ���  ��  ��  l ��� Z   y �������� E  y ���� J   y }�� ��� m   y z��
�� LeTrTCha� ���� m   z {��
�� LeTrBCha��  � J   } ��� ���� o   } ~���� 0 whichend whichEnd��  � V   � ���� r   � ���� \   � ���� o   � ����� 0 endindex endIndex� m   � ����� � o      ���� 0 endindex endIndex� =  � ���� n   � ���� 4   � ����
�� 
cha � o   � ����� 0 endindex endIndex� o   � ��� 0 thetext theText� m   � ��� ���  ��  ��  � ��~� L   � ��� n   � ���� 7  � ��}��
�} 
ctxt� o   � ��|�| 0 
startindex 
startIndex� o   � ��{�{ 0 endindex endIndex� o   � ��z�z 0 thetext theText�~  M �y�
�y conscase� �x�
�x consdiac� �w�
�w conshyph� �v�u
�v conspunc�u  N �t�
�t consnume� �s�r
�s conswhit�r  ��  % R      �q��
�q .ascrerr ****      � ****� o      �p�p 0 etext eText� �o��
�o 
errn� o      �n�n 0 enumber eNumber� �m��
�m 
erob� o      �l�l 0 efrom eFrom� �k��j
�k 
errt� o      �i�i 
0 eto eTo�j  & I   � ��h��g�h 
0 _error  � ��� m   � ��� ���  t r i m   t e x t� ��� o   � ��f�f 0 etext eText� ��� o   � ��e�e 0 enumber eNumber� ��� o   � ��d�d 0 efrom eFrom� ��c� o   � ��b�b 
0 eto eTo�c  �g   ��� l     �a�`�_�a  �`  �_  � ��� l     �^�]�\�^  �]  �\  � ��� l     �[���[  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     �Z���Z  �   Split and Join Suite   � ��� *   S p l i t   a n d   J o i n   S u i t e� ��� l     �Y�X�W�Y  �X  �W  � ��� i  g j��� I      �V��U�V 0 
_linebreak  � ��T� o      �S�S 0 linebreaktype lineBreakType�T  �U  � l    /���� Z     /����� =    ��� o     �R�R 0 linebreaktype lineBreakType� m    �Q
�Q LiBrLiOX� L    	�� 1    �P
�P 
lnfd� ��� =   ��� o    �O�O 0 linebreaktype lineBreakType� m    �N
�N LiBrLiCM� ��� L    �� o    �M
�M 
ret � ��� =   ��� o    �L�L 0 linebreaktype lineBreakType� m    �K
�K LiBrLiWi� ��J� L    !�� b     ��� o    �I
�I 
ret � 1    �H
�H 
lnfd�J  � n  $ /��� I   ) /�G��F�G >0 throwinvalidconstantparameter throwInvalidConstantParameter� ��� o   ) *�E�E 0 linebreaktype lineBreakType� ��D� m   * +�� ��� 
 u s i n g�D  �F  � o   $ )�C�C 0 _support  � < 6 used by `join paragraphs` and `normalize line breaks`   � ��� l   u s e d   b y   ` j o i n   p a r a g r a p h s `   a n d   ` n o r m a l i z e   l i n e   b r e a k s `� ��� l     �B�A�@�B  �A  �@  � ��� l     �?�>�=�?  �>  �=  � ��� i  k n��� I      �<��;�< 0 
_splittext 
_splitText� ��� o      �:�: 0 thetext theText� ��9� o      �8�8 0 theseparator theSeparator�9  �;  � l    ^�� � k     ^  r      n    
 I    
�7�6�7 "0 aslistparameter asListParameter 	�5	 o    �4�4 0 theseparator theSeparator�5  �6   o     �3�3 0 _support   o      �2�2 0 delimiterlist delimiterList 

 X    C�1 Q    > l    ) r     ) c     % n     # 1   ! #�0
�0 
pcnt o     !�/�/ 0 aref aRef m   # $�.
�. 
ctxt n       1   & (�-
�- 
pcnt o   % &�,�, 0 aref aRef�� caution: AS silently ignores invalid TID values, so separator items must be explicitly validated to catch any user errors; for now, just coerce to text and catch errors, but might want to make it more rigorous in future (e.g. if a list of lists is given, should sublist be treated as an error instead of just coercing it to text, which is itself TIDs sensitive); see also existing TODO on TypeSupport's asTextParameter handler    �V   c a u t i o n :   A S   s i l e n t l y   i g n o r e s   i n v a l i d   T I D   v a l u e s ,   s o   s e p a r a t o r   i t e m s   m u s t   b e   e x p l i c i t l y   v a l i d a t e d   t o   c a t c h   a n y   u s e r   e r r o r s ;   f o r   n o w ,   j u s t   c o e r c e   t o   t e x t   a n d   c a t c h   e r r o r s ,   b u t   m i g h t   w a n t   t o   m a k e   i t   m o r e   r i g o r o u s   i n   f u t u r e   ( e . g .   i f   a   l i s t   o f   l i s t s   i s   g i v e n ,   s h o u l d   s u b l i s t   b e   t r e a t e d   a s   a n   e r r o r   i n s t e a d   o f   j u s t   c o e r c i n g   i t   t o   t e x t ,   w h i c h   i s   i t s e l f   T I D s   s e n s i t i v e ) ;   s e e   a l s o   e x i s t i n g   T O D O   o n   T y p e S u p p o r t ' s   a s T e x t P a r a m e t e r   h a n d l e r R      �+�*
�+ .ascrerr ****      � ****�*   �)�(
�) 
errn d       m      �'�'��(   n  1 > !  I   6 >�&"�%�& 60 throwinvalidparametertype throwInvalidParameterType" #$# o   6 7�$�$ 0 aref aRef$ %&% m   7 8'' �((  u s i n g   s e p a r a t o r& )*) m   8 9�#
�# 
ctxt* +�"+ m   9 :,, �--  l i s t   o f   t e x t�"  �%  ! o   1 6�!�! 0 _support  �1 0 aref aRef o    � �  0 delimiterlist delimiterList ./. r   D I010 n  D G232 1   E G�
� 
txdl3 1   D E�
� 
ascr1 o      �� 0 oldtids oldTIDs/ 454 r   J O676 o   J K�� 0 delimiterlist delimiterList7 n     898 1   L N�
� 
txdl9 1   K L�
� 
ascr5 :;: r   P U<=< n   P S>?> 2  Q S�
� 
citm? o   P Q�� 0 thetext theText= o      �� 0 
resultlist 
resultList; @A@ r   V [BCB o   V W�� 0 oldtids oldTIDsC n     DED 1   X Z�
� 
txdlE 1   W X�
� 
ascrA F�F L   \ ^GG o   \ ]�� 0 
resultlist 
resultList�  � � � used by `split text` to split text using one or more text item delimiters and current or predefined considering/ignoring settings     �HH   u s e d   b y   ` s p l i t   t e x t `   t o   s p l i t   t e x t   u s i n g   o n e   o r   m o r e   t e x t   i t e m   d e l i m i t e r s   a n d   c u r r e n t   o r   p r e d e f i n e d   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s� IJI l     ����  �  �  J KLK l     ����  �  �  L MNM i  o rOPO I      �Q�
� 0 _splitpattern _splitPatternQ RSR o      �	�	 0 thetext theTextS T�T o      �� 0 patterntext patternText�  �
  P l    �UVWU k     �XX YZY r     [\[ n    ]^] I    �_�� @0 asnsregularexpressionparameter asNSRegularExpressionParameter_ `a` o    �� 0 patterntext patternTexta bcb m    ��  c d�d m    ee �ff  a t�  �  ^ o     �� 0 _support  \ o      � �  0 asocpattern asocPatternZ ghg r    iji n   klk I    ��m���� ,0 asnormalizednsstring asNormalizedNSStringm n��n o    ���� 0 thetext theText��  ��  l o    ���� 0 _support  j o      ���� 0 
asocstring 
asocStringh opo l   qrsq r    tut m    ����  u o      ���� &0 asocnonmatchstart asocNonMatchStartr G A used to calculate NSRanges for non-matching portions of NSString   s �vv �   u s e d   t o   c a l c u l a t e   N S R a n g e s   f o r   n o n - m a t c h i n g   p o r t i o n s   o f   N S S t r i n gp wxw r     $yzy J     "����  z o      ���� 0 
resultlist 
resultListx {|{ l  % %��}~��  } @ : iterate over each non-matched + matched range in NSString   ~ � t   i t e r a t e   o v e r   e a c h   n o n - m a t c h e d   +   m a t c h e d   r a n g e   i n   N S S t r i n g| ��� r   % 6��� n  % 4��� I   & 4������� @0 matchesinstring_options_range_ matchesInString_options_range_� ��� o   & '���� 0 
asocstring 
asocString� ��� m   ' (����  � ���� J   ( 0�� ��� m   ( )����  � ���� n  ) .��� I   * .�������� 
0 length  ��  ��  � o   ) *���� 0 
asocstring 
asocString��  ��  ��  � o   % &���� 0 asocpattern asocPattern� o      ����  0 asocmatcharray asocMatchArray� ��� Y   7 ~�������� k   G y�� ��� r   G T��� l  G R������ n  G R��� I   M R������� 0 rangeatindex_ rangeAtIndex_� ���� m   M N����  ��  ��  � l  G M������ n  G M��� I   H M�������  0 objectatindex_ objectAtIndex_� ���� o   H I���� 0 i  ��  ��  � o   G H����  0 asocmatcharray asocMatchArray��  ��  ��  ��  � o      ����  0 asocmatchrange asocMatchRange� ��� r   U \��� n  U Z��� I   V Z�������� 0 location  ��  ��  � o   U V����  0 asocmatchrange asocMatchRange� o      ����  0 asocmatchstart asocMatchStart� ��� r   ] o��� c   ] l��� l  ] j������ n  ] j��� I   ^ j������� *0 substringwithrange_ substringWithRange_� ���� K   ^ f�� ������ 0 location  � o   _ `���� &0 asocnonmatchstart asocNonMatchStart� ������� 
0 length  � \   a d��� o   a b����  0 asocmatchstart asocMatchStart� o   b c���� &0 asocnonmatchstart asocNonMatchStart��  ��  ��  � o   ] ^���� 0 
asocstring 
asocString��  ��  � m   j k��
�� 
ctxt� n      ���  ;   m n� o   l m���� 0 
resultlist 
resultList� ���� r   p y��� [   p w��� o   p q����  0 asocmatchstart asocMatchStart� l  q v������ n  q v��� I   r v�������� 
0 length  ��  ��  � o   q r����  0 asocmatchrange asocMatchRange��  ��  � o      ���� &0 asocnonmatchstart asocNonMatchStart��  �� 0 i  � m   : ;����  � \   ; B��� l  ; @������ n  ; @��� I   < @�������� 	0 count  ��  ��  � o   ; <����  0 asocmatcharray asocMatchArray��  ��  � m   @ A���� ��  � ��� l   ������  � "  add final non-matched range   � ��� 8   a d d   f i n a l   n o n - m a t c h e d   r a n g e� ��� r    ���� c    ���� l   ������� n   ���� I   � �������� *0 substringfromindex_ substringFromIndex_� ���� o   � ����� &0 asocnonmatchstart asocNonMatchStart��  ��  � o    ����� 0 
asocstring 
asocString��  ��  � m   � ���
�� 
ctxt� n      ���  ;   � �� o   � ����� 0 
resultlist 
resultList� ���� L   � ��� o   � ����� 0 
resultlist 
resultList��  V Q K used by `split text` to split text using a regular expression as separator   W ��� �   u s e d   b y   ` s p l i t   t e x t `   t o   s p l i t   t e x t   u s i n g   a   r e g u l a r   e x p r e s s i o n   a s   s e p a r a t o rN ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  s v��� I      ������� 0 	_jointext 	_joinText� ��� o      ���� 0 thelist theList� ���� o      ���� 0 separatortext separatorText��  ��  � k     5�� ��� r     ��� n    ��� 1    ��
�� 
txdl� 1     ��
�� 
ascr� o      ���� 0 oldtids oldTIDs� ��� r    ��� o    ���� 0 delimiterlist delimiterList� n     ��� 1    
��
�� 
txdl� 1    ��
�� 
ascr� ��� Q    ,���� r    � � c     o    ���� 0 thelist theList m    ��
�� 
ctxt  o      ���� 0 
resulttext 
resultText� R      ����
�� .ascrerr ****      � ****��   ����
�� 
errn d       m      �������  � k    ,  r    !	
	 o    ���� 0 oldtids oldTIDs
 n      1     ��
�� 
txdl 1    ��
�� 
ascr �� R   " ,��
�� .ascrerr ****      � **** m   * + � b I n v a l i d   d i r e c t   p a r a m e t e r   ( e x p e c t e d   l i s t   o f   t e x t ) . ��
�� 
errn m   $ %�����Y ��
�� 
erob o   & '���� 0 thelist theList ����
�� 
errt m   ( )��
�� 
list��  ��  �  r   - 2 o   - .���� 0 oldtids oldTIDs n      1   / 1��
�� 
txdl 1   . /��
�� 
ascr � L   3 5 o   3 4�~�~ 0 
resulttext 
resultText�  �   l     �}�|�{�}  �|  �{    !"! l     �z�y�x�z  �y  �x  " #$# l     �w%&�w  %  -----   & �'' 
 - - - - -$ ()( l     �v�u�t�v  �u  �t  ) *+* i  w z,-, I     �s./
�s .Txt:SplTnull���     ctxt. o      �r�r 0 thetext theText/ �q01
�q 
Sepa0 |�p�o2�n3�p  �o  2 o      �m�m 0 theseparator theSeparator�n  3 l     4�l�k4 m      �j
�j 
msng�l  �k  1 �i5�h
�i 
Usin5 |�g�f6�e7�g  �f  6 o      �d�d 0 matchformat matchFormat�e  7 l     8�c�b8 m      �a
�a SerECmpI�c  �b  �h  - k     �99 :;: l     �`<=�`  <rl convenience handler for splitting text using TIDs that can also use a regular expression pattern as separator; note that this is similar to using `search text theText for theSeparator returning non matching text` (except that `search text` returns start and end indexes as well as text), but avoids some of the overhead and is an obvious complement to `join text`   = �>>�   c o n v e n i e n c e   h a n d l e r   f o r   s p l i t t i n g   t e x t   u s i n g   T I D s   t h a t   c a n   a l s o   u s e   a   r e g u l a r   e x p r e s s i o n   p a t t e r n   a s   s e p a r a t o r ;   n o t e   t h a t   t h i s   i s   s i m i l a r   t o   u s i n g   ` s e a r c h   t e x t   t h e T e x t   f o r   t h e S e p a r a t o r   r e t u r n i n g   n o n   m a t c h i n g   t e x t `   ( e x c e p t   t h a t   ` s e a r c h   t e x t `   r e t u r n s   s t a r t   a n d   e n d   i n d e x e s   a s   w e l l   a s   t e x t ) ,   b u t   a v o i d s   s o m e   o f   t h e   o v e r h e a d   a n d   i s   a n   o b v i o u s   c o m p l e m e n t   t o   ` j o i n   t e x t `; ?�_? Q     �@AB@ k    �CC DED r    FGF n   HIH I    �^J�]�^ "0 astextparameter asTextParameterJ KLK o    	�\�\ 0 thetext theTextL M�[M m   	 
NN �OO  �[  �]  I o    �Z�Z 0 _support  G o      �Y�Y 0 thetext theTextE P�XP Z    �QRSTQ =   UVU o    �W�W 0 theseparator theSeparatorV m    �V
�V 
msngR l   7WXYW k    7ZZ [\[ r    ]^] I   �U_�T
�U .Txt:TrmTnull���     ctxt_ o    �S�S 0 thetext theText�T  ^ o      �R�R 0 thetext theText\ `a` Z   .bc�Q�Pb =    $ded n   "fgf 1     "�O
�O 
lengg o     �N�N 0 thetext theTexte m   " #�M�M  c L   ' *hh J   ' )�L�L  �Q  �P  a i�Ki L   / 7jj I   / 6�Jk�I�J 0 _splitpattern _splitPatternk lml o   0 1�H�H 0 thetext theTextm n�Gn m   1 2oo �pp  \ s +�G  �I  �K  X � � if `at` parameter is omitted, trims ends then splits on whitespace runs by default same as Python's str.split() default behavior (any `using` options are ignored)   Y �qqF   i f   ` a t `   p a r a m e t e r   i s   o m i t t e d ,   t r i m s   e n d s   t h e n   s p l i t s   o n   w h i t e s p a c e   r u n s   b y   d e f a u l t   s a m e   a s   P y t h o n ' s   s t r . s p l i t ( )   d e f a u l t   b e h a v i o r   ( a n y   ` u s i n g `   o p t i o n s   a r e   i g n o r e d )S rsr =  : =tut o   : ;�F�F 0 matchformat matchFormatu m   ; <�E
�E SerECmpIs vwv P   @ Nxyzx L   E M{{ I   E L�D|�C�D 0 
_splittext 
_splitText| }~} o   F G�B�B 0 thetext theText~ �A o   G H�@�@ 0 theseparator theSeparator�A  �C  y �?�
�? consdiac� �>�
�> conshyph� �=�
�= conspunc� �<�
�< conswhit� �;�:
�; consnume�:  z �9�8
�9 conscase�8  w ��� =  Q T��� o   Q R�7�7 0 matchformat matchFormat� m   R S�6
�6 SerECmpP� ��� L   W _�� I   W ^�5��4�5 0 _splitpattern _splitPattern� ��� o   X Y�3�3 0 thetext theText� ��2� o   Y Z�1�1 0 theseparator theSeparator�2  �4  � ��� =  b e��� o   b c�0�0 0 matchformat matchFormat� m   c d�/
�/ SerECmpC� ��� P   h v���.� L   m u�� I   m t�-��,�- 0 
_splittext 
_splitText� ��� o   n o�+�+ 0 thetext theText� ��*� o   o p�)�) 0 theseparator theSeparator�*  �,  � �(�
�( conscase� �'�
�' consdiac� �&�
�& conshyph� �%�
�% conspunc� �$�
�$ conswhit� �#�"
�# consnume�"  �.  � ��� =  y |��� o   y z�!�! 0 matchformat matchFormat� m   z {� 
�  SerECmpE� ��� P    ����� L   � ��� I   � ����� 0 
_splittext 
_splitText� ��� o   � ��� 0 thetext theText� ��� o   � ��� 0 theseparator theSeparator�  �  � ��
� conscase� ��
� consdiac� ��
� conshyph� ��
� conspunc� ��
� conswhit�  � ��
� consnume�  � ��� =  � ���� o   � ��� 0 matchformat matchFormat� m   � ��
� SerECmpD� ��� L   � ��� I   � ����� 0 
_splittext 
_splitText� ��� o   � ��� 0 thetext theText� ��� o   � ��� 0 theseparator theSeparator�  �  �  T n  � ���� I   � ��
��	�
 >0 throwinvalidconstantparameter throwInvalidConstantParameter� ��� o   � ��� 0 matchformat matchFormat� ��� m   � ��� ��� 
 u s i n g�  �	  � o   � ��� 0 _support  �X  A R      ���
� .ascrerr ****      � ****� o      �� 0 etext eText� ���
� 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      � �  0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  B I   � �������� 
0 _error  � ��� m   � ��� ���  s p l i t   t e x t� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  �_  + ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  { ~��� I     ����
�� .Txt:JoiTnull���     ****� o      ���� 0 thelist theList� �����
�� 
Sepa� |����������  ��  � o      ���� 0 separatortext separatorText��  � m      �� ���  ��  � Q     0���� L    �� I    ������� 0 	_jointext 	_joinText� ��� n   ��� I   	 ������� "0 aslistparameter asListParameter� ���� o   	 
���� 0 thelist theList��  ��  � o    	���� 0 _support  � ���� n   ��� I    ������� "0 astextparameter asTextParameter� ��� o    ���� 0 separatortext separatorText� ���� m    �� ���  u s i n g   s e p a r a t o r��  ��  � o    ���� 0 _support  ��  ��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ��� 
�� 
erob� o      ���� 0 efrom eFrom  ����
�� 
errt o      ���� 
0 eto eTo��  � I   & 0������ 
0 _error    m   ' ( �  j o i n   t e x t  o   ( )���� 0 etext eText 	
	 o   ) *���� 0 enumber eNumber
  o   * +���� 0 efrom eFrom �� o   + ,���� 
0 eto eTo��  ��  �  l     ��������  ��  ��    l     ��������  ��  ��    i   � I     ����
�� .Txt:SplPnull���     ctxt o      ���� 0 thetext theText��   Q     $ L     n     2   ��
�� 
cpar n    I    ������ "0 astextparameter asTextParameter  !  o    	���� 0 thetext theText! "��" m   	 
## �$$  ��  ��   o    ���� 0 _support   R      ��%&
�� .ascrerr ****      � ****% o      ���� 0 etext eText& ��'(
�� 
errn' o      ���� 0 enumber eNumber( ��)*
�� 
erob) o      ���� 0 efrom eFrom* ��+��
�� 
errt+ o      ���� 
0 eto eTo��   I    $��,���� 
0 _error  , -.- m    // �00   s p l i t   p a r a g r a p h s. 121 o    ���� 0 etext eText2 343 o    ���� 0 enumber eNumber4 565 o    ���� 0 efrom eFrom6 7��7 o     ���� 
0 eto eTo��  ��   898 l     ��������  ��  ��  9 :;: l     ��������  ��  ��  ; <=< i  � �>?> I     ��@A
�� .Txt:JoiPnull���     ****@ o      ���� 0 thelist theListA ��B��
�� 
LiBrB |����C��D��  ��  C o      ���� 0 linebreaktype lineBreakType��  D l     E����E m      ��
�� LiBrLiOX��  ��  ��  ? Q     +FGHF L    II I    ��J���� 0 	_jointext 	_joinTextJ KLK n   MNM I   	 ��O���� "0 aslistparameter asListParameterO P��P o   	 
���� 0 thelist theList��  ��  N o    	���� 0 _support  L Q��Q I    ��R���� 0 
_linebreak  R S��S o    ���� 0 linebreaktype lineBreakType��  ��  ��  ��  G R      ��TU
�� .ascrerr ****      � ****T o      ���� 0 etext eTextU ��VW
�� 
errnV o      ���� 0 enumber eNumberW ��XY
�� 
erobX o      ���� 0 efrom eFromY ��Z��
�� 
errtZ o      ���� 
0 eto eTo��  H I   ! +��[���� 
0 _error  [ \]\ m   " #^^ �__  j o i n   p a r a g r a p h s] `a` o   # $���� 0 etext eTexta bcb o   $ %���� 0 enumber eNumberc ded o   % &���� 0 efrom eFrome f��f o   & '�� 
0 eto eTo��  ��  = ghg l     �~�}�|�~  �}  �|  h i�{i l     �z�y�x�z  �y  �x  �{       "�wjk�v�u�tlmnopqrstuvwxyz{|}~���������w  j  �s�r�q�p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V�U�T
�s 
pimr�r (0 _unmatchedtexttype _UnmatchedTextType�q $0 _matchedtexttype _MatchedTextType�p &0 _matchedgrouptype _MatchedGroupType�o 0 _support  �n 
0 _error  �m $0 _matchinforecord _matchInfoRecord�l 0 _matchrecords _matchRecords�k &0 _matchedgrouplist _matchedGroupList�j 0 _findpattern _findPattern�i "0 _replacepattern _replacePattern�h 0 	_findtext 	_findText�g 0 _replacetext _replaceText
�f .Txt:Srchnull���     ctxt
�e .Txt:EPatnull���     ctxt
�d .Txt:ETemnull���     ctxt
�c .Txt:UppTnull���     ctxt
�b .Txt:CapTnull���     ctxt
�a .Txt:LowTnull���     ctxt
�` .Txt:FTxtnull���     ctxt
�_ .Txt:NLiBnull���     ctxt
�^ .Txt:PadTnull���     ctxt
�] .Txt:SliTnull���     ctxt
�\ .Txt:TrmTnull���     ctxt�[ 0 
_linebreak  �Z 0 
_splittext 
_splitText�Y 0 _splitpattern _splitPattern�X 0 	_jointext 	_joinText
�W .Txt:SplTnull���     ctxt
�V .Txt:JoiTnull���     ****
�U .Txt:SplPnull���     ctxt
�T .Txt:JoiPnull���     ****k �S��S �  �� �R��Q
�R 
cobj� ��   �P 
�P 
frmk�Q  
�v 
TxtU
�u 
TxtM
�t 
TxtGl ��   �O C
�O 
scptm �N M�M�L���K�N 
0 _error  �M �J��J �  �I�H�G�F�E�I 0 handlername handlerName�H 0 etext eText�G 0 enumber eNumber�F 0 efrom eFrom�E 
0 eto eTo�L  � �D�C�B�A�@�D 0 handlername handlerName�C 0 etext eText�B 0 enumber eNumber�A 0 efrom eFrom�@ 
0 eto eTo�  ]�?�>�? �> &0 throwcommanderror throwCommandError�K b  ࠡ����+ n �= ��<�;���:�= $0 _matchinforecord _matchInfoRecord�< �9��9 �  �8�7�6�5�8 0 
asocstring 
asocString�7  0 asocmatchrange asocMatchRange�6 0 
textoffset 
textOffset�5 0 
recordtype 
recordType�;  � �4�3�2�1�0�/�4 0 
asocstring 
asocString�3  0 asocmatchrange asocMatchRange�2 0 
textoffset 
textOffset�1 0 
recordtype 
recordType�0 0 	foundtext 	foundText�/  0 nexttextoffset nextTextOffset� �.�-�,�+�*�)�(�'�. *0 substringwithrange_ substringWithRange_
�- 
ctxt
�, 
leng
�+ 
pcls�* 0 
startindex 
startIndex�) 0 endindex endIndex�( 0 	foundtext 	foundText�' �: $��k+  �&E�O���,E�O���k���lvo �& ��%�$���#�& 0 _matchrecords _matchRecords�% �"��" �  �!� �����! 0 
asocstring 
asocString�   0 asocmatchrange asocMatchRange�  0 asocstartindex asocStartIndex� 0 
textoffset 
textOffset� (0 nonmatchrecordtype nonMatchRecordType� "0 matchrecordtype matchRecordType�$  � ������������ 0 
asocstring 
asocString�  0 asocmatchrange asocMatchRange�  0 asocstartindex asocStartIndex� 0 
textoffset 
textOffset� (0 nonmatchrecordtype nonMatchRecordType� "0 matchrecordtype matchRecordType�  0 asocmatchstart asocMatchStart� 0 asocmatchend asocMatchEnd� &0 asocnonmatchrange asocNonMatchRange� 0 nonmatchinfo nonMatchInfo� 0 	matchinfo 	matchInfo� ������ 0 location  � 
0 length  � � $0 _matchinforecord _matchInfoRecord
� 
cobj�# W�j+  E�O��j+ E�O�ᦢ�E�O*�����+ E[�k/E�Z[�l/E�ZO*�����+ E[�k/E�Z[�l/E�ZO�����vp ��
�	���� &0 _matchedgrouplist _matchedGroupList�
 ��� �  ����� 0 
asocstring 
asocString� 0 	asocmatch 	asocMatch� 0 
textoffset 
textOffset� &0 includenonmatches includeNonMatches�	  � ��� ��������������������� 0 
asocstring 
asocString� 0 	asocmatch 	asocMatch�  0 
textoffset 
textOffset�� &0 includenonmatches includeNonMatches�� "0 submatchresults subMatchResults�� 0 groupindexes groupIndexes�� (0 asocfullmatchrange asocFullMatchRange�� &0 asocnonmatchstart asocNonMatchStart�� $0 asocfullmatchend asocFullMatchEnd�� 0 i  �� 0 nonmatchinfo nonMatchInfo�� 0 	matchinfo 	matchInfo�� &0 asocnonmatchrange asocNonMatchRange� 	��������������������  0 numberofranges numberOfRanges�� 0 rangeatindex_ rangeAtIndex_�� 0 location  �� 
0 length  �� �� 0 _matchrecords _matchRecords
�� 
cobj�� �� $0 _matchinforecord _matchInfoRecord� �jvE�O�j+  kE�O�j ��jk+ E�O�j+ E�O��j+ E�O Uk�kh 	*���k+ ��b  b  �+ E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO� 	��6FY hO��6F[OY��O� #�㨧�E�O*���b  �+ �k/�6FY hY hO�q ������������� 0 _findpattern _findPattern�� ����� �  ���������� 0 thetext theText�� 0 patterntext patternText�� &0 includenonmatches includeNonMatches��  0 includematches includeMatches��  � �������������������������������� 0 thetext theText�� 0 patterntext patternText�� &0 includenonmatches includeNonMatches��  0 includematches includeMatches�� 0 asocpattern asocPattern�� 0 
asocstring 
asocString�� &0 asocnonmatchstart asocNonMatchStart�� 0 
textoffset 
textOffset�� 0 
resultlist 
resultList��  0 asocmatcharray asocMatchArray�� 0 i  �� 0 	asocmatch 	asocMatch�� 0 nonmatchinfo nonMatchInfo�� 0 	matchinfo 	matchInfo�� 0 	foundtext 	foundText� ������������������������������������������������� (0 asbooleanparameter asBooleanParameter�� @0 asnsregularexpressionparameter asNSRegularExpressionParameter�� ,0 asnormalizednsstring asNormalizedNSString�� 
0 length  �� @0 matchesinstring_options_range_ matchesInString_options_range_�� 	0 count  ��  0 objectatindex_ objectAtIndex_�� 0 rangeatindex_ rangeAtIndex_�� �� 0 _matchrecords _matchRecords
�� 
cobj�� �� 0 foundgroups foundGroups�� 0 
startindex 
startIndex�� &0 _matchedgrouplist _matchedGroupList�� *0 substringfromindex_ substringFromIndex_
�� 
ctxt
�� 
pcls�� 0 endindex endIndex
�� 
leng�� 0 	foundtext 	foundText�� ��b  ��l+ E�Ob  ��l+ E�Ob  �j�m+ E�Ob  �k+ E�OjE�OkE�OjvE�O��jj�j+ lvm+ E�O }j�j+ kkh 
��k+ 	E�O*��jk+ 
��b  b  �+ E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO� 	��6FY hO� ��*���a ,��+ l%�6FY h[OY��O� 1��k+ a &E�Oa b  a �a �a ,a �a �6FY hO�r ������������� "0 _replacepattern _replacePattern�� ����� �  �������� 0 thetext theText�� 0 patterntext patternText�� 0 templatetext templateText��  � ������������������������������������������ 0 thetext theText�� 0 patterntext patternText�� 0 templatetext templateText�� 0 
asocstring 
asocString�� 0 asocpattern asocPattern�� 0 
resultlist 
resultList�� &0 asocnonmatchstart asocNonMatchStart�� 0 
textoffset 
textOffset��  0 asocmatcharray asocMatchArray�� 0 i  �� 0 	asocmatch 	asocMatch�� 0 nonmatchinfo nonMatchInfo�� 0 	matchinfo 	matchInfo�� 0 matchedgroups matchedGroups�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo�� 0 oldtids oldTIDs�� 0 
resulttext 
resultText� ��������������������������������������������H���p��� ,0 asnormalizednsstring asNormalizedNSString�� @0 asnsregularexpressionparameter asNSRegularExpressionParameter
�� 
kocl
�� 
scpt
�� .corecnte****       ****
�� 
cobj�� 
0 length  �� @0 matchesinstring_options_range_ matchesInString_options_range_�� 	0 count  ��  0 objectatindex_ objectAtIndex_�� 0 rangeatindex_ rangeAtIndex_�� �� 0 _matchrecords _matchRecords�� �� 0 	foundtext 	foundText�� 0 
startindex 
startIndex�� &0 _matchedgrouplist _matchedGroupList��  0 replacepattern replacePattern
�� 
ctxt� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  
� 
errn
� 
erob
� 
errt� *0 substringfromindex_ substringFromIndex_
� 
ascr
� 
txdl� |0 <stringbyreplacingmatchesinstring_options_range_withtemplate_ <stringByReplacingMatchesInString_options_range_withTemplate_��Mb  �k+  E�Ob  �j�m+ E�O�kv��l jjvjkmvE[�k/E�Z[�l/E�Z[�m/E�ZO��jj�j+ lvm+ E�O �j�j+ 	kkh 	��k+ 
E�O*��jk+ ��b  b  �+ E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO��,�6FO*���a ,e�+ E�O ���,�l+ a &�6FW X  )a �a ] a ] �a �%[OY�qO��k+ a &�6FO_ a ,E^ Oa _ a ,FO�a &E^ O] _ a ,FO] Y ��jj�j+ lv��+ s ����~���}� 0 	_findtext 	_findText� �|��| �  �{�z�y�x�{ 0 thetext theText�z 0 fortext forText�y &0 includenonmatches includeNonMatches�x  0 includematches includeMatches�~  � 
�w�v�u�t�s�r�q�p�o�n�w 0 thetext theText�v 0 fortext forText�u &0 includenonmatches includeNonMatches�t  0 includematches includeMatches�s 0 
resultlist 
resultList�r 0 oldtids oldTIDs�q 0 
startindex 
startIndex�p 0 endindex endIndex�o 0 	foundtext 	foundText�n 0 i  � ��m�l�k�j��i�h�g�f�e��d�c�b�a�`�_8�^�]p
�m 
errn�l�Y
�k 
erob�j 
�i 
ascr
�h 
txdl
�g 
citm
�f 
leng
�e 
ctxt
�d 
pcls�c 0 
startindex 
startIndex�b 0 endindex endIndex�a 0 	foundtext 	foundText�` 
�_ .corecnte****       ****�^ 0 foundgroups foundGroups�] 
�})��  )�����Y hOjvE�O��,E�O���,FOkE�O��k/�,E�O� 2�� �[�\[Z�\Z�2E�Y �E�O�b  ����a �6FY hO �l��-j kh 	�kE�O��,�[�\[�/\�i/2�,E�O� 9�� �[�\[Z�\Z�2E�Y a E�O�b  ����a jva �6FY hO�kE�O���/�,kE�O� 4�� �[�\[Z�\Z�2E�Y a E�O�b  ����a �6FY h[OY�WO���,FO�t �\��[�Z���Y�\ 0 _replacetext _replaceText�[ �X��X �  �W�V�U�W 0 thetext theText�V 0 fortext forText�U 0 newtext newText�Z  � �T�S�R�Q�P�O�N�M�L�K�J�I�H�G�T 0 thetext theText�S 0 fortext forText�R 0 newtext newText�Q 0 oldtids oldTIDs�P 0 
resultlist 
resultList�O 0 
startindex 
startIndex�N 0 endindex endIndex�M 0 i  �L 0 	foundtext 	foundText�K 0 etext eText�J 0 enumber eNumber�I 0 efrom eFrom�H 
0 eto eTo�G 0 
resulttext 
resultText� ��F�E�D�C��B�A�@�?�>�=�<�;�: �9�8��7�6<j��5
�F 
errn�E�Y
�D 
erob�C 
�B 
ascr
�A 
txdl
�@ 
kocl
�? 
scpt
�> .corecnte****       ****
�= 
citm
�< 
leng
�; 
cobj
�: 
ctxt�9 0 replacetext replaceText�8 0 etext eText� �4�3�
�4 
errn�3 0 enumber eNumber� �2�1�
�2 
erob�1 0 efrom eFrom� �0�/�.
�0 
errt�/ 
0 eto eTo�.  
�7 
errt�6 �5 "0 astextparameter asTextParameter�Y=��  )�����Y hO��,E�O���,FO�kv��l 
j �jvk��k/�,mvE[�k/E�Z[�l/E�Z[�m/E�ZO�� �[�\[Z�\Z�2�6FY hO �l��-j 
kh �kE�O��,�[�\[�/\�i/2�,E�O�� �[�\[Z�\Z�2E�Y �E�O ��k+ �&�6FW X  )��a �a a �%O�kE�O���/�,kE�O�� �[�\[Z�\Z�2�6FY h[OY�pOa ��,FY b  �a l+ E�O��-E�O���,FO��&E�O���,FO�u �-��,�+���*
�- .Txt:Srchnull���     ctxt�, 0 thetext theText�+ �)�(�
�) 
For_�( 0 fortext forText� �'��
�' 
Usin� {�&�%�$�& 0 matchformat matchFormat�%  
�$ SerECmpI� �#��
�# 
Repl� {�"�!� �" 0 newtext newText�!  
�  
msng� ���
� 
Retu� {���� 0 resultformat resultFormat�  
� RetEMatT�  � ������������ 0 thetext theText� 0 fortext forText� 0 matchformat matchFormat� 0 newtext newText� 0 resultformat resultFormat� &0 includenonmatches includeNonMatches�  0 includematches includeMatches� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� %��������
��	����/��9:��� ��^��tu���������������� "0 astextparameter asTextParameter
� 
leng
� 
errn��Y
� 
erob�
 
�	 
msng
� RetEMatT
� 
cobj
� RetEUmaT
� RetEAllT� >0 throwinvalidconstantparameter throwInvalidConstantParameter
� SerECmpI� 0 	_findtext 	_findText
� SerECmpP�  0 _findpattern _findPattern
�� SerECmpC
�� SerECmpE
�� SerECmpD�� 0 _replacetext _replaceText�� "0 _replacepattern _replacePattern�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �*��b  ��l+ E�Ob  ��l+ E�O��,j  )�����Y hO��  ���  felvE[�k/E�Z[�l/E�ZY E��  eflvE[�k/E�Z[�l/E�ZY )��  eelvE[�k/E�Z[�l/E�ZY b  ��l+ O�a   a a  *�����+ VY u�a   *�����+ Y `�a   a g *�����+ VY C�a   a a  *�����+ VY $�a   *�����+ Y b  �a l+ Y ��a   a a  *���m+ VY q�a   *���m+ Y ]�a   a a  *���m+ VY ?�a   a g *���m+ VY #�a   *���m+ Y b  �a l+ W X   !*a "����a #+ $v ����������
�� .Txt:EPatnull���     ctxt�� 0 thetext theText��  � ������������ 0 thetext theText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ����)���������7����
�� misccura�� *0 nsregularexpression NSRegularExpression�� "0 astextparameter asTextParameter�� 40 escapedpatternforstring_ escapedPatternForString_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� + ��,b  ��l+ k+ �&W X  *衢���+ 
w ��G��������
�� .Txt:ETemnull���     ctxt�� 0 thetext theText��  � ������������ 0 thetext theText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ����[���������i����
�� misccura�� *0 nsregularexpression NSRegularExpression�� "0 astextparameter asTextParameter�� 60 escapedtemplateforstring_ escapedTemplateForString_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� + ��,b  ��l+ k+ �&W X  *衢���+ 
x ��������
�� .Txt:UppTnull���     ctxt� 0 thetext theText� ���
� 
Loca� {���� 0 
localecode 
localeCode�  �  � �������� 0 thetext theText� 0 
localecode 
localeCode� 0 
asocstring 
asocString� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� ��������������� "0 astextparameter asTextParameter� 0 
asnsstring 
asNSString
� 
msng� "0 uppercasestring uppercaseString
� 
ctxt� *0 asnslocaleparameter asNSLocaleParameter� 80 uppercasestringwithlocale_ uppercaseStringWithLocale_� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  � Q @b  b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ k+ �&W X 	 
*룤���+ y �������
� .Txt:CapTnull���     ctxt� 0 thetext theText� ���
� 
Loca� {���� 0 
localecode 
localeCode�  �  � �������� 0 thetext theText� 0 
localecode 
localeCode� 0 
asocstring 
asocString� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� ������������� "0 astextparameter asTextParameter� 0 
asnsstring 
asNSString
� 
msng� &0 capitalizedstring capitalizedString
� 
ctxt� *0 asnslocaleparameter asNSLocaleParameter� <0 capitalizedstringwithlocale_ capitalizedStringWithLocale_� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  � Q @b  b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ k+ �&W X 	 
*룤���+ z �-��~���}
� .Txt:LowTnull���     ctxt� 0 thetext theText�~ �|��{
�| 
Loca� {�z�y4�z 0 
localecode 
localeCode�y  �{  � �x�w�v�u�t�s�r�x 0 thetext theText�w 0 
localecode 
localeCode�v 0 
asocstring 
asocString�u 0 etext eText�t 0 enumber eNumber�s 0 efrom eFrom�r 
0 eto eTo� H�q�p�o�n�me�l�k�j�q�i�h�q "0 astextparameter asTextParameter�p 0 
asnsstring 
asNSString
�o 
msng�n "0 lowercasestring lowercaseString
�m 
ctxt�l *0 asnslocaleparameter asNSLocaleParameter�k 80 lowercasestringwithlocale_ lowercaseStringWithLocale_�j 0 etext eText� �g�f�
�g 
errn�f 0 enumber eNumber� �e�d�
�e 
erob�d 0 efrom eFrom� �c�b�a
�c 
errt�b 
0 eto eTo�a  �i �h 
0 _error  �} Q @b  b  ��l+ k+ E�O��  �j+ �&Y �b  ��l+ k+ �&W X 	 
*룤���+ { �`��_�^���]
�` .Txt:FTxtnull���     ctxt�_ 0 templatetext templateText�^ �\�[�Z
�\ 
Usin�[ 0 	thevalues 	theValues�Z  � �Y�X�W�V�U�T�S�R�Q�P�O�N�M�L�K�J�I�H�Y 0 templatetext templateText�X 0 	thevalues 	theValues�W 0 asocpattern asocPattern�V 0 
asocstring 
asocString�U  0 asocmatcharray asocMatchArray�T 0 resulttexts resultTexts�S 0 
startindex 
startIndex�R 0 i  �Q 0 
matchrange 
matchRange�P 0 thetoken theToken�O 0 	itemindex 	itemIndex�N 0 theitem theItem�M 0 oldtids oldTIDs�L 0 
resulttext 
resultText�K 0 etext eText�J 0 enumber eNumber�I 0 efrom eFrom�H 
0 eto eTo� (���G�F�E��D�C�B�A�@�?�>�=�<�;�:�9�8	�7�6�5��4�3�2�1�0	O	Q�/�.�-	��,�	��+�*�G "0 aslistparameter asListParameter
�F misccura�E *0 nsregularexpression NSRegularExpression
�D 
msng�C Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_�B 0 
asnsstring 
asNSString�A 
0 length  �@ @0 matchesinstring_options_range_ matchesInString_options_range_�? 	0 count  �>  0 objectatindex_ objectAtIndex_�= 0 rangeatindex_ rangeAtIndex_�< 0 location  �; �: *0 substringwithrange_ substringWithRange_
�9 
ctxt
�8 
cha 
�7 
long
�6 
cobj�5  � �)�(�'
�) 
errn�(�\�'  
�4 
errn�3�\
�2 
erob
�1 
errt�0 �/ *0 substringfromindex_ substringFromIndex_
�. 
ascr
�- 
txdl�, 0 etext eText� �&�%�
�& 
errn�% 0 enumber eNumber� �$�#�
�$ 
erob�# 0 efrom eFrom� �"�!� 
�" 
errt�! 
0 eto eTo�   �+ �* 
0 _error  �]\C��;b  �k+ E�O��,�j�m+ E�Ob  �k+ E�O��jj�j+ 	lvm+ 
E�OjvE�OjE�O �j�j+ kkh ��k+ jk+ E�O���j+ ��k+ a &�6FO��k+ a &E�O�a k/a   �a l/�6FY O�a l/a &E�O�a �/E�O �a &�6FW +X  )a a a �a �/a a a a �%a %O�j+ �j+ 	E�[OY�RO��k+ a &�6FO_  a !,E�Oa "_  a !,FO�a &E�O�_  a !,FO�VW X # $*a %��] ] a &+ '| �	������
� .Txt:NLiBnull���     ctxt� 0 thetext theText� ���
� 
LiBr� {���� 0 linebreaktype lineBreakType�  
� LiBrLiOX�  � ������� 0 thetext theText� 0 linebreaktype lineBreakType� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� 
	�������	���
� "0 astextparameter asTextParameter
� 
cpar� 0 
_linebreak  � 0 	_jointext 	_joinText� 0 etext eText� �	��
�	 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � �
 
0 _error  � / *b  ��l+ �-*�k+ l+ W X  *碣���+ 	} �	��� ����
� .Txt:PadTnull���     ctxt� 0 thetext theText�  �����
�� 
toPl�� 0 	textwidth 	textWidth� ����
�� 
Char� {����	��� 0 padtext padText��  � �����
�� 
From� {�������� 0 whichend whichEnd��  
�� LeTrLCha��  � ������������������������ 0 thetext theText�� 0 	textwidth 	textWidth�� 0 padtext padText�� 0 whichend whichEnd�� 0 
widthtoadd 
widthToAdd�� 0 padsize padSize�� 0 	padoffset 	padOffset�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� 
	��
����
1��������
C��������
������
������� "0 astextparameter asTextParameter�� (0 asintegerparameter asIntegerParameter
�� 
leng
�� 
errn���Y
�� 
erob�� 
�� LeTrLCha
�� 
ctxt
�� LeTrTCha
�� LeTrBCha�� >0 throwinvalidconstantparameter throwInvalidConstantParameter�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� �b  ��l+ E�Ob  ��l+ E�O���,E�O�j �Y hOb  ��l+ E�O��,E�O��,j  )�����Y hO h��,����%E�[OY��O��  �[�\[Zk\Z�2�%Y s��  ��,�#E�O��[�\[Zk�\Z��2%Y P��  ?�k �[�\[Zk\Z�l"2�%E�Y hO��,�#E�O��[�\[Zk�\Z��kl"2%Y b  ��l+ W X  *a ����a + ~ ��
���������
�� .Txt:SliTnull���     ctxt�� 0 thetext theText�� ����
�� 
FIdx� {�������� 0 
startindex 
startIndex��  
�� 
msng� �����
�� 
TIdx� {�������� 0 endindex endIndex��  
�� 
msng��  � ����������������� 0 thetext theText�� 0 
startindex 
startIndex�� 0 endindex endIndex�� 0 	thelength 	theLength�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom� 
0 eto eTo� 
�������%�9�C[��i}��������� "0 astextparameter asTextParameter
� 
leng
� 
errn��Y
� 
erob� 
� 
msng� (0 asintegerparameter asIntegerParameter
� 
ctxt��[
� 
bool� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  ����b  ��l+ E�O��,E�O�j  -�j  )�����Y hO�j  )�����Y hO�Y hO�� Tb  ��l+ E�O�j  )�����Y hO��  )��' �Y �� �Y �[�\[Z�\Zi2EY hY ��  )�a la Y hO�� Zb  �a l+ E�O�j  )����a Y hO��  +��' 	a Y �� �Y �[�\[Zk\Z�2EY hY hO�j �k�E�Y hO�j �k�E�Y hO��
 �k	 	�ka &a &
 ��	 	��a &a & 	a Y hO�k kE�Y �� �E�Y hO�k kE�Y �� �E�Y hO�[�\[Z�\Z�2EW X  *a ����a +  ������
� .Txt:TrmTnull���     ctxt� 0 thetext theText� ���
� 
From� {���� 0 whichend whichEnd�  
� LeTrBCha�  � ��������� 0 thetext theText� 0 whichend whichEnd� 0 
startindex 
startIndex� 0 endindex endIndex� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� 2����I�MNY\����������� "0 astextparameter asTextParameter
� LeTrLCha
� LeTrTCha
� LeTrBCha� >0 throwinvalidconstantparameter throwInvalidConstantParameter
� 
cobj
� 
cha 
� 
ctxt� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  � � �b  ��l+ E�O���mv�kv b  ��l+ Y hO�� {��  �Y hOkilvE[�k/E�Z[�l/E�ZO��lv�kv  h��/� �kE�[OY��Y hO��lv�kv  h��/� �kE�[OY��Y hO�[�\[Z�\Z�2EVW X  *a ����a + � �������� 0 
_linebreak  � ��� �  �� 0 linebreaktype lineBreakType�  � �� 0 linebreaktype lineBreakType� ��~�}�|�{��z
� LiBrLiOX
�~ 
lnfd
�} LiBrLiCM
�| 
ret 
�{ LiBrLiWi�z >0 throwinvalidconstantparameter throwInvalidConstantParameter� 0��  �EY %��  �Y ��  	��%Y b  ��l+ � �y��x�w���v�y 0 
_splittext 
_splitText�x �u��u �  �t�s�t 0 thetext theText�s 0 theseparator theSeparator�w  � �r�q�p�o�n�m�r 0 thetext theText�q 0 theseparator theSeparator�p 0 delimiterlist delimiterList�o 0 aref aRef�n 0 oldtids oldTIDs�m 0 
resultlist 
resultList� �l�k�j�i�h�g�f�',�e�d�c�b�a�l "0 aslistparameter asListParameter
�k 
kocl
�j 
cobj
�i .corecnte****       ****
�h 
pcnt
�g 
ctxt�f  � �`�_�^
�` 
errn�_�\�^  �e �d 60 throwinvalidparametertype throwInvalidParameterType
�c 
ascr
�b 
txdl
�a 
citm�v _b  �k+  E�O 5�[��l kh  ��,�&��,FW X  b  �����+ [OY��O��,E�O���,FO��-E�O���,FO�� �]P�\�[���Z�] 0 _splitpattern _splitPattern�\ �Y��Y �  �X�W�X 0 thetext theText�W 0 patterntext patternText�[  � 
�V�U�T�S�R�Q�P�O�N�M�V 0 thetext theText�U 0 patterntext patternText�T 0 asocpattern asocPattern�S 0 
asocstring 
asocString�R &0 asocnonmatchstart asocNonMatchStart�Q 0 
resultlist 
resultList�P  0 asocmatcharray asocMatchArray�O 0 i  �N  0 asocmatchrange asocMatchRange�M  0 asocmatchstart asocMatchStart� e�L�K�J�I�H�G�F�E�D�C�B�A�L @0 asnsregularexpressionparameter asNSRegularExpressionParameter�K ,0 asnormalizednsstring asNormalizedNSString�J 
0 length  �I @0 matchesinstring_options_range_ matchesInString_options_range_�H 	0 count  �G  0 objectatindex_ objectAtIndex_�F 0 rangeatindex_ rangeAtIndex_�E 0 location  �D �C *0 substringwithrange_ substringWithRange_
�B 
ctxt�A *0 substringfromindex_ substringFromIndex_�Z �b  �j�m+ E�Ob  �k+ E�OjE�OjvE�O��jj�j+ lvm+ E�O Fj�j+ kkh ��k+ jk+ E�O�j+ E�O��㩤�k+ 
�&�6FO��j+ E�[OY��O��k+ �&�6FO�� �@��?�>� �=�@ 0 	_jointext 	_joinText�? �<�<   �;�:�; 0 thelist theList�: 0 separatortext separatorText�>  � �9�8�7�6�5�9 0 thelist theList�8 0 separatortext separatorText�7 0 oldtids oldTIDs�6 0 delimiterlist delimiterList�5 0 
resulttext 
resultText  �4�3�2�1�0�/�.�-�,�+
�4 
ascr
�3 
txdl
�2 
ctxt�1   �*�)�(
�* 
errn�)�\�(  
�0 
errn�/�Y
�. 
erob
�- 
errt
�, 
list�+ �= 6��,E�O���,FO 
��&E�W X  ���,FO)�������O���,FO�� �'-�&�%�$
�' .Txt:SplTnull���     ctxt�& 0 thetext theText�% �#
�# 
Sepa {�"�!� �" 0 theseparator theSeparator�!  
�  
msng ��
� 
Usin {���� 0 matchformat matchFormat�  
� SerECmpI�   �������� 0 thetext theText� 0 theseparator theSeparator� 0 matchformat matchFormat� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo N����o��yz�����
���	������� "0 astextparameter asTextParameter
� 
msng
� .Txt:TrmTnull���     ctxt
� 
leng� 0 _splitpattern _splitPattern
� SerECmpI� 0 
_splittext 
_splitText
� SerECmpP
� SerECmpC
�
 SerECmpE
�	 SerECmpD� >0 throwinvalidconstantparameter throwInvalidConstantParameter� 0 etext eText ��	
� 
errn� 0 enumber eNumber	 ��

� 
erob� 0 efrom eFrom
 � ����
�  
errt�� 
0 eto eTo��  � � 
0 _error  �$ � �b  ��l+ E�O��  %�j E�O��,j  jvY hO*��l+ Y z��  �� *��l+ 
VY c��  *��l+ Y R��  �g *��l+ 
VY ;��  �a  *��l+ 
VY "�a   *��l+ 
Y b  �a l+ W X  *a ����a + � ���������
�� .Txt:JoiTnull���     ****�� 0 thelist theList�� ����
�� 
Sepa {������� 0 separatortext separatorText��  ��   �������������� 0 thelist theList�� 0 separatortext separatorText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo 	��������������� "0 aslistparameter asListParameter�� "0 astextparameter asTextParameter�� 0 	_jointext 	_joinText�� 0 etext eText ����
�� 
errn�� 0 enumber eNumber ����
�� 
erob�� 0 efrom eFrom ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� 1  *b  �k+  b  ��l+ l+ W X  *梣���+ � ��������
�� .Txt:SplPnull���     ctxt�� 0 thetext theText��   ������������ 0 thetext theText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo #������/������ "0 astextparameter asTextParameter
�� 
cpar�� 0 etext eText ����
�� 
errn�� 0 enumber eNumber ����
�� 
erob�� 0 efrom eFrom ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� % b  ��l+ �-EW X  *塢���+ � ��?������
�� .Txt:JoiPnull���     ****�� 0 thelist theList�� ����
�� 
LiBr {�������� 0 linebreaktype lineBreakType��  
�� LiBrLiOX��   ������������� 0 thelist theList�� 0 linebreaktype lineBreakType�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom� 
0 eto eTo ����^��� "0 aslistparameter asListParameter� 0 
_linebreak  � 0 	_jointext 	_joinText� 0 etext eText ��
� 
errn� 0 enumber eNumber ��
� 
erob� 0 efrom eFrom ���
� 
errt� 
0 eto eTo�  � � 
0 _error  �� , *b  �k+  *�k+ l+ W X  *墣���+ ascr  ��ޭ